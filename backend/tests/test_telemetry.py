from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_device_and_telemetry_flow():
    # Register and login
    email = "sensoruser@example.com"
    pw = "secret"
    r = client.post('/auth/register', json={"email": email, "password": pw})
    assert r.status_code == 200
    token = r.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    # Create device
    r = client.post('/devices/', json={"name": "TestSensor"}, headers=headers)
    assert r.status_code == 200
    device = r.json()
    device_id = device["id"] if isinstance(device, dict) and "id" in device else device['id'] if isinstance(device, dict) else None
    assert device_id is not None

    # Post telemetry
    r = client.post('/telemetry/', json={"device_id": device_id, "humidity": 85, "inclination": 12}, headers=headers)
    assert r.status_code == 200
    d = r.json()
    assert 'reading_id' in d
    assert len(d['alerts']) >= 1
