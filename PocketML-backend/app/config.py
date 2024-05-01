from pydantic_settings import BaseSettings, SettingsConfigDict
import os

os.chdir(os.path.dirname(__file__)[:-4])


class Settings(BaseSettings):
    PROJECT_NAME: str = "PocketML"
    API_V1_STR: str = "/api/v1"
    PORT: int = 8000

    DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%S"

    DATABASE_URL: str = "sqlite:///./app.db"
    CONNECT_ARGS: dict = {"check_same_thread": False}
    DEBUG: bool = True  # TODO: change to false for production
    FIREBASE_SDK_JSON: str = "./firebase-admin-sdk-for-pocketml.json"

    DUMMY_USER_DANIEL: dict = {
        "name": "Daniel",
        "email": "cndanielwang3@gmail.com",  # Fake email
        "password": "password",  # not my real password
        "email_notif": True
    }

    AWS_ACCESS_KEY_ID: str
    AWS_SECRET_ACCESS_KEY: str

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
        env_ignore_empty=True
    )


settings = Settings()
