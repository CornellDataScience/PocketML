from typing import Annotated

from fastapi import HTTPException, Depends, Request, status
from firebase_admin.auth import RevokedIdTokenError, ExpiredIdTokenError, CertificateFetchError, UserDisabledError
from sqlmodel import Session
from database import engine
from config import settings

import firebase_admin
from firebase_admin import credentials, auth

try:
    cred = credentials.Certificate(settings.FIREBASE_SDK_JSON)
    firebase_admin.initialize_app(cred)
    print("Firebase SDK initialized")
except ValueError as e:
    print("Error initializing Firebase SDK:", e)


def get_db_session():
    with Session(engine) as session:
        yield session


SessionDependency = Annotated[Session, Depends(get_db_session)]


def get_user_token(request: Request):
    token = request.headers.get("Authorization")
    if not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Can not find the authorization token.")

    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except ExpiredIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Token has expired.")
    except RevokedIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Token has been revoked.")
    except CertificateFetchError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Could not fetch the certificate.")
    except UserDisabledError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="User has been disabled.")


def get_user_token_dummy(request: Request):
    if "email" in list(request.headers.keys()):
        email = request.headers["email"]
        password = request.headers["password"]
        # if user is None:
        #     raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
        #                         detail="User for this task is not found. Please contact us.")

    else:
        print('WARNING: Using dummy user')
        email = settings.DUMMY_USER_DANIEL["email"]
        password = settings.DUMMY_USER_DANIEL['password']
    return {"email": email, "password": password}


# # TODO: Implement the get_user_token function
# UserTokenDependency = Depends(get_user_token)
# TODO: add Annotated makes it doesn't work (sth concerns with the generic class)
UserTokenDependency = Depends(get_user_token_dummy)
