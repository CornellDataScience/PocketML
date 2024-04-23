from fastapi import APIRouter, Depends, status

router = APIRouter()


@router.post("/create_user", status_code=status.HTTP_201_CREATED)
async def create_user():
    """
    Creates a new user by adding the user to firebase and S3
    :return:
    """
    return {"message": "User created successfully"}


@router.get("/get_me", status_code=status.HTTP_200_OK, dependencies=[])
async def get_me():
    """
    Retrieves the current user from firebase. If the user does not exist, return a 404
    :return: the uid of the user on firebase
    """
    return {"message": "User retrieved successfully"}
