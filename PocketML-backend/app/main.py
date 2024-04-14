from fastapi import FastAPI
from fastapi import APIRouter
from fastapi.routing import APIRoute

from .routers import users
from .config import settings

api_router = APIRouter()
api_router.include_router(users.router, prefix="/users", tags=["users"])

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

app.include_router(api_router, prefix=settings.API_V1_STR, tags=["root"])


@app.get("/")
async def index():
    return {"message": "Welcome to PocketML"}
