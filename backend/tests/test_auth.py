from fastapi.testclient import TestClient
from app.main import app
import os

client = TestClient(app)

def test_register_and_login():
    # Register
    resp = client.post('/auth/register', json={"email": "test@example.com", "password": "secret"})
    assert resp.status_code == 200
    data = resp.json()
    assert 'access_token' in data

    # Login
    resp2 = client.post('/auth/login', data={"username": "test@example.com", "password": "secret"})
    assert resp2.status_code == 200
    data2 = resp2.json()
    assert 'access_token' in data2
