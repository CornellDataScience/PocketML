from fastapi import APIRouter, Depends, status, HTTPException
from models import CreateJob, Job
from dependencies import SessionDependency

router = APIRouter()


@router.get("/create_job", status_code=status.HTTP_201_CREATED)
async def create_job(new_job: CreateJob, session: SessionDependency):
    """
    Creates a new job by adding them to 
    """

    return


@router.get("/api/v1/jobs/{job_id}", status_code=status.HTTP_200_OK, dependencies=[])
async def get_jobs(job_id: int):
    """
    Retrieves all jobs
    :return: a list of all jobs
    """

    job = session.get(job_id)

    return
