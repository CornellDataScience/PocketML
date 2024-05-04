from fastapi import FastAPI
from fastapi import APIRouter
from fastapi.routing import APIRoute

from api import users, jobs
from config import settings

from database import create_db_and_tables

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


from motor.motor_asyncio import AsyncIOMotorClient

client = AsyncIOMotorClient("mongodb://localhost:27010")
db = client.your_database_name


@app.get('/a')
async def a():
    items = []
    # Use async for to iterate over cursor
    async for item in db.items.find():
        items.append(item)
    return {"items": items}


@app.on_event("startup")
def on_startup():
    print("Starting up PocketML backend")

    create_db_and_tables()
    print("PocketML backend started")
