from fastapi.testclient import TestClient

from main import app
from config import settings
import os

client = TestClient(app, base_url=F"http://testserver:{settings.PORT}/api/v1")

daniel_user = settings.DUMMY_USER_DANIEL
header = {"email": daniel_user["email"], "password": daniel_user["password"]}  # This is only for testing purposes

token = None

if not os.path.exists('../../app.db'):
    from database import create_db_and_tables

    create_db_and_tables()


def test_create_job():
    response = client.post("/jobs/create_job", json={
    }, )
