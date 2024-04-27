from fastapi.testclient import TestClient

from main import app

client = TestClient(app)

daniel_user = {
    "name": "Daniel",
    "email": "cndanielwang@gmail.com",
    "password": "password",
    "email_notif": True
}

token = None


def test_add_user():
    response = client.post("/users/create_user", json=daniel_user)

    assert response.status_code == 201
    assert "token" in list(response.json().keys())


def test_login():
    response = client.post("/users/login", json=daniel_user)

    assert response.status_code == 200
    assert "token" in list(response.json().keys())
    assert response.json()["token"] != ""

    global token
    token = response.json()["token"]


def test_get_me():
    if token is None:
        test_login()
    response = client.get("/users/get_me", headers={"Authorization": f"Bearer {token}"})

    assert response.status_code == 200
    print(response.json())
