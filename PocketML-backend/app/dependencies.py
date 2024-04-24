from typing import Annotated

from fastapi import HTTPException, Depends, Request, status
from fastapi.security import OAuth2PasswordBearer
from sqlmodel import Session
from database import engine
from config import settings

import firebase_admin
from firebase_admin import credentials, auth


def get_db_session():
    with Session(engine) as session:
        yield session


SessionDependency = Annotated[Session, Depends(get_db_session)]


def get_current_user(request: Request):
    token = request.headers.get("Authorization")
    if not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Can not find the authorization token.")


def user_authenticated(firebase_user):
    if not firebase_user:
        raise HTTPException(status_code=400, detail="Unauthorized user")
    return firebase_user
