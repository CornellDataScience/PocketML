from fastapi import APIRouter, Depends, status, HTTPException
from models import JobCreate, Job, User, JobUpdate, dict_to_str, str_to_dict
from dependencies import SessionDependency, UserTokenDependency

router = APIRouter()


@router.post("/create_job", status_code=status.HTTP_201_CREATED)
async def create_job(new_job: JobCreate, session: SessionDependency, token: dict = UserTokenDependency):
    """
    Creates a new job by adding them to 
    """
    if session.query(Job).filter(Job.name == new_job.name).first() is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Job already exists")

    job = Job(
        name=new_job.name,
        wandb=new_job.wandb,
        wandb_link=new_job.wandb_link,
        start_time=new_job.start_time,
        config=dict_to_str(new_job.config),
        cluster_name=new_job.cluster_name,
        current_step=0,
        current_status="stopped",
        last_update_time="undefined"
    )

    user = session.query(User).filter(User.email == token["email"]).first()
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="User for this task is not found. Please contact us.")
    user.jobs.append(job)
    session.add(job)
    session.commit()

    return {"detail": f"Job {new_job.name} created successfully"}


@router.get("/api/v1/jobs/{job_id}", status_code=status.HTTP_200_OK, dependencies=[], response_model=Job,
            response_model_exclude={'config'})
async def get_job(job_id: int, session: SessionDependency, token: dict = UserTokenDependency):
    """
    retrieve a job by its id
    """
    # Check for authentication
    job = session.query(Job).filter(Job.id == job_id).first()
    if job is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Job not found")
    return job


@router.put("/api/v1/jobs/{job_id}", status_code=status.HTTP_200_OK, dependencies=[], response_model=Job,
            response_model_exclude={'config'})
async def update_job(*, session: SessionDependency, job_update: JobUpdate) -> Job:
    """
    Update the job with the given name
    """
    job = session.query(Job).filter(Job.id == job_update.id).first()
    if not job:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Internal error: could not find the job in the database")

    for key, value in job_update.model_dump(exclude_unset=True).items():
        setattr(job, key, value)
    session.commit()
    return job
