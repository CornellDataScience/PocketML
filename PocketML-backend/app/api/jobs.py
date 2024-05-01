from fastapi import APIRouter, Depends, status, HTTPException
from models import CreateJob, Job, User
from dependencies import SessionDependency, UserTokenDependency

router = APIRouter()


@router.get("/create_job", status_code=status.HTTP_201_CREATED)
async def create_job(new_job: CreateJob, session: SessionDependency, token: dict = UserTokenDependency):
    """
    Creates a new job by adding them to 
    """
    if session.query(Job).filter(Job.name == new_job.name).first() is not None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Job already exists")

    job = Job(**{
        **new_job.dict(),
        "user_email": token["email"],
    })

    user = session.query(User).filter(User.email == token["email"]).first()
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="User for this task is not found. Please contact us.")
    user.jobs.append(job)
    session.add(job)
    session.commit()

    return {"detail": f"Job {new_job.name} created successfully"}


@router.get("/api/v1/jobs/{job_id}", status_code=status.HTTP_200_OK, dependencies=[])
async def get_jobs(job_id: int):
    """
    Retrieves all jobs
    :return: a list of all jobs
    """

    job = session.get(job_id)

    return
