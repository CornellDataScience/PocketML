from fastapi import FastAPI
from fastapi import APIRouter
from fastapi.routing import APIRoute

from api import users, jobs
from config import settings

from sqlmodel import SQLModel, create_engine

api_router = APIRouter()
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(jobs.router, prefix="/jobs", tags=["jobs"])

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

app.include_router(api_router, prefix=settings.API_V1_STR, tags=["root"])


@app.get("/", status_code=200)
async def index():
    return {"message": "Welcome to PocketML"}


@app.on_event("startup")
def on_startup():
    print("Starting up PocketML backend")

    def create_db_and_tables():
        """
        Handles the creation of the database and tables
        """
        connect_args = {"check_same_thread": False}
        engine = create_engine(url=settings.DATABASE_URL, echo=True, connect_args=connect_args)
        SQLModel.metadata.create_all(engine)

    create_db_and_tables()
    print("PocketML backend started")
