from pydantic_settings import BaseSettings, SettingsConfigDict
import os

os.chdir(os.path.dirname(__file__)[:-4])


class Settings(BaseSettings):
    PROJECT_NAME: str = "PocketML"
    API_V1_STR: str = "/api/v1"

    DATABASE_URL: str = "sqlite:///./app.db"

    FIREBASE_SDK_JSON: str = "./firebase-admin-sdk-for-pocketml.json"

    AWS_ACCESS_KEY_ID: str
    AWS_SECRET_ACCESS_KEY: str

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
        env_ignore_empty=True
    )


settings = Settings()
