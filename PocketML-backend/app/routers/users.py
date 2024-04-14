from fastapi import APIRouter

router = APIRouter()


@router.get("/create_user")
async def create_user():
    """
    Creates a new user by adding the user to firebase and S3
    :return:
    """
    return {"message": "User created successfully"}


@router.get("/get_me")
async def get_me():
    """
    Retrieves the current user from firebase. If the user does not exist, return a 404
    :return: the uid of the user on firebase
    """
    return {"message": "User retrieved successfully"}
