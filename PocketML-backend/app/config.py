from pydantic_settings import BaseSettings, SettingsConfigDict
import json
import os

os.chdir(os.path.dirname(__file__)[:-4])


class Settings(BaseSettings):
    PROJECT_NAME: str = "PocketML"
    API_V1_STR: str = "/api/v1"
    PORT: int = 8000

    DATETIME_FORMAT: str = "%Y-%m-%dT%H:%M:%S"

    DATABASE_URL: str = "sqlite:///./app.db"
    CONNECT_ARGS: dict = {"check_same_thread": False}
    DEBUG: bool = True  # TODO: change to false for production

    FIREBASE_SDK_JSON: str = "./firebase-admin-sdk-for-pocketml.json"
    FIREBASE_PRIVATE_KEY_ID: str = os.getenv('FIREBASE_PRIVATE_KEY_ID', "")
    FIREBASE_PRIVATE_KEY: str = os.getenv('FIREBASE_PRIVATE_KEY', "")
    FIREBASE_SDK_DICT: dict = {}

    DUMMY_USER_DANIEL: dict = {
        "name": "Daniel",
        "email": "cndanielwang3@gmail.com",  # Fake email
        "password": "password",  # not my real password
        "email_notif": True
    }

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
        env_ignore_empty=True
    )


def fix_string(s):
    """Fixes strings which are transferred. String that contains new lines

    """
    return s.replace('\\n', '\n').encode('utf-8')


def set_firebase_sdk(settings: Settings):
    with open(settings.FIREBASE_SDK_JSON, 'r') as json_file:
        data = json.load(json_file)
    data['private_key_id'] = fix_string(settings.FIREBASE_PRIVATE_KEY_ID)
    data['private_key'] = fix_string(settings.FIREBASE_PRIVATE_KEY)
    settings.FIREBASE_SDK_DICT = data


settings = Settings()
set_firebase_sdk(settings)
