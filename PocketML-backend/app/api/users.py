from fastapi import APIRouter, status, HTTPException
from models import UserCreate, User
from dependencies import SessionDependency, UserTokenDependency

from crud import _create_user, _get_user_by_email

from firebase_admin import auth

router = APIRouter()


@router.post("/create_user", status_code=status.HTTP_201_CREATED)
async def create_user(new_user: UserCreate, session: SessionDependency):
    """
    Creates a new user by adding the user to firebase and S3
    :return:
    """
    user = _get_user_by_email(session=session, email=new_user.email)

    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="User already exists")

    firebase_uid = _create_user(session=session, user_create=new_user)

    token = auth.create_custom_token(firebase_uid)

    return {"token": token}


@router.get("/get_me", status_code=status.HTTP_200_OK, response_model=User,
            response_model_exclude={'hashed_password'})
async def get_me(session: SessionDependency, token: dict = UserTokenDependency):
    """
    Retrieves the current user from firebase. If the user does not exist, return a 404
    :return: the uid of the user on firebase
    """
    user = session.get(User, token["email"])
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found. Please contact us.")

    return user
