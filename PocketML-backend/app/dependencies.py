from fastapi import HTTPException


def user_authenticated(firebase_user):
    if not firebase_user:
        raise HTTPException(status_code=400, detail="Unauthorized user")
    return firebase_user
