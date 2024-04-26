from fastapi import HTTPException
from firebase_admin.exceptions import FirebaseError
from sqlmodel import Session, create_engine, select
from typing import Any

from starlette import status

from config import settings
from models import User, CreateUser

from firebase_admin import auth

engine = create_engine(str(settings.DATABASE_URL))


def _get_user_by_email(*, session: Session, email: str) -> User:
    statement = select(User).where(User.email == email)
    user = session.exec(statement).first()
    return user


def _create_user(*, session: Session, user_create: CreateUser) -> str:
    """
    Precondition: The user does not exist in the database

    :return the firebase uid of the user
    """
    try:
        firebase_uid = auth.create_user(
            email=user_create.email,
            password=user_create.password,
            display_name=user_create.name
        ).uid
    except FirebaseError:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Could not create user in Firebase")

    new_user = User(
        email=user_create.email,
        name=user_create.name,
        email_notif=user_create.email_notif,
        is_active=True,
        is_superuser=False
    )

    session.add(new_user)
    session.commit()
    session.refresh(new_user)

    return firebase_uid


def _update_user(*, session: Session, db_user: User, user_in: UserUpdate) -> Any:
    user_data = user_in.model_dump(exclude_unset=True)
    extra_data = {}
    if "password" in user_data:
        password = user_data["password"]
        hashed_password = get_password_hash(password)
        extra_data["hashed_password"] = hashed_password
    db_user.sqlmodel_update(user_data, update=extra_data)
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user


def authenticate(*, session: Session, email: str, password: str) -> User:
    db_user = get_user_by_email(session=session, email=email)
    if not db_user:
        return None
    if not verify_password(password, db_user.hashed_password):
        return None
    return db_user
