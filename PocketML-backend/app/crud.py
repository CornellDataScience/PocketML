from fastapi import HTTPException
from firebase_admin.exceptions import FirebaseError
from sqlmodel import Session, select
from typing import Any

from starlette import status

from models import *

from firebase_admin import auth


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
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="Could not create user in Firebase")

    new_user = User(
        email=user_create.email,
        name=user_create.name,
        email_notif=user_create.email_notif,
        password=user_create.password,  # TODO remove this
        firebase_uid=firebase_uid,
        is_active=True,
        is_superuser=False
    )

    session.add(new_user)
    session.commit()
    session.refresh(new_user)

    return firebase_uid


def _login_user(*, session: Session, user_login: UserLogin) -> str:
    """
    :return: the firebase uid of the user
    """
    user = _get_user_by_email(session=session, email=user_login.email)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    if user.password != user_login.password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Incorrect password")

    return user.firebase_uid


def _update_user(*, session: Session, user_in: UserUpdate) -> User:
    """
    :return: the updated user
    """
    user = session.exec(select(User).where(
        User.email == user_in.email)).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Internal error: could not find the user in the database")

    for key, value in user_in.model_dump(exclude_unset=True).items():
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


def _get_job_by_name(*, session: Session, name: str) -> Job:
    """
    :return: the job with the given name
    """
    statement = select(Job).where(Job.name == name)
    job = session.exec(statement).first()
    return job


def _create_job(*, session: Session, job_create: JobCreate) -> Job:
    """
    Precondition: The job does not exist in the database
    
    :return: the created job
    """
    new_job = Job(
        name=job_create.name,
        wandb=job_create.wandb,
        wandb_link=job_create.wandb_link,
        start_time=job_create.start_time,
        config=job_create.config,
        cluster_name=job_create.cluster_name,
        current_step=0,
        current_status="stopped",
        last_update_time="undefined"
    )

    session.add(new_job)
    session.commit()
    session.refresh(new_job)

    return new_job


def _update_job(*, session: Session, job_update: JobUpdate) -> Job:
    """
    Update the job with the given name
    """
    job = session.exec(select(Job).where(Job.name == job_update.name)).first()
    if not job:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Internal error: could not find the job in the database")

    for key, value in job_update.model_dump(exclude_unset=True).items():
        setattr(job, key, value)
    session.commit()

    return job
