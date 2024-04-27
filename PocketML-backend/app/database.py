from fastapi import HTTPException
from firebase_admin.exceptions import FirebaseError
from sqlmodel import Session, create_engine, select
from typing import Any

from starlette import status

from config import settings
from models import User, UserCreate, UserUpdate

from firebase_admin import auth

engine = create_engine(str(settings.DATABASE_URL))


def _get_user_by_email(*, session: Session, email: str) -> User:
    statement = select(User).where(User.email == email)
    user = session.exec(statement).first()
    return user


def _create_user(*, session: Session, user_create: UserCreate) -> str:
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
        firebase_uid=firebase_uid,
        is_active=True,
        is_superuser=False
    )

    session.add(new_user)
    session.commit()
    session.refresh(new_user)

    return firebase_uid


def _update_user(*, session: Session, user_in: UserUpdate) -> User:
    """
    :return: the updated user
    """
    user = session.exec(select(User).where(User.email == user_in.email)).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Internal error: could not find the user in the database")

    for key, value in user_in.dict(exclude_unset=True).items():
        setattr(user, key, value)
    session.commit()

    return user


def _delete_user(*, session: Session, user: User) -> Any:
    """
    Precondition: The user exists in the database
    :return: the deleted user
    """
    auth.delete_user(user.firebase_uid)
    session.delete(user)
    session.commit()
    return user
