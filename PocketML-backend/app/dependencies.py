from typing import Annotated

from fastapi import HTTPException, Depends, Request, status
from firebase_admin.auth import RevokedIdTokenError, ExpiredIdTokenError, CertificateFetchError, UserDisabledError
from sqlmodel import Session
from database import engine
from config import settings

import firebase_admin
from firebase_admin import credentials, auth

cred = credentials.Certificate(settings.FIREBASE_SDK_JSON)
firebase_admin.initialize_app(cred)


def get_db_session():
    with Session(engine) as session:
        yield session


SessionDependency = Annotated[Session, Depends(get_db_session)]


def get_current_user(request: Request):
    token = request.headers.get("Authorization")
    if not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Can not find the authorization token.")

    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except ExpiredIdTokenError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token has expired.")
    except RevokedIdTokenError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token has been revoked.")
    except CertificateFetchError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Could not fetch the certificate.")
    except UserDisabledError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User has been disabled.")


CurrentUserDependency = Annotated[dict, Depends(get_current_user)]
