from fastapi import APIRouter, Depends, status

router = APIRouter()


@router.get("/", status_code=status.HTTP_200_OK, dependencies=[])
async def get_jobs():
    """
    Retrieves all jobs
    :return: a list of all jobs
    """
    return {"message": "Jobs retrieved successfully"}
