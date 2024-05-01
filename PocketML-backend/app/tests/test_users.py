from fastapi.testclient import TestClient

from main import app
from config import settings
import os

client = TestClient(app, base_url=f"http://testserver:{settings.PORT}/api/v1")

daniel_user = settings.DUMMY_USER_DANIEL

token = None

if not os.path.exists('../../app.db'):
    from database import create_db_and_tables

    create_db_and_tables()


def test_add_user():
    response = client.post("/users/create_user", json=daniel_user)
    if response.status_code != 201:
        print("-- -- -- --")
        print(response.json())
        print("-- -- -- --")

    assert response.status_code == 201
    assert "token" in list(response.json().keys())


def test_login():
    response = client.post("/users/login", json=daniel_user)

    assert response.status_code == 200
    # # MINORTODO: uncomment this when the token is returned
    # assert "token" in list(response.json().keys())
    # assert response.json()["token"] != ""
    # global token
    # token = response.json()["token"]


def test_get_me():
    if token is None:
        test_login()
    response = client.get("/users/get_me", headers={"Authorization": f"Bearer {token}"})
    if response.status_code != 200:
        print("-- -- -- --")
        print(response.json())
        print("-- -- -- --")
    assert response.status_code == 200
    print(response.json())
