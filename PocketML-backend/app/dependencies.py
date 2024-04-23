from typing import Annotated

from fastapi import HTTPException, Depends
from sqlmodel import Session
from database import engine


def get_db_session():
    with Session(engine) as session:
        yield session


SessionDependency = Annotated[Session, Depends(get_db_session)]


def user_authenticated(firebase_user):
    if not firebase_user:
        raise HTTPException(status_code=400, detail="Unauthorized user")
    return firebase_user
