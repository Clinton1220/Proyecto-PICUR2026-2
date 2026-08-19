from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session
from app.models import Reading, Device, get_session
from app.schemas import TelemetryCreate
from app.routes.auth import get_current_user
from datetime import datetime

router = APIRouter()

@router.post("/")
def post_telemetry(payload: TelemetryCreate, current_user = Depends(get_current_user), session: Session = Depends(get_session)):
    # Verify device exists and belongs to user
    device = session.get(Device, payload.device_id)
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")
    if device.owner_id != current_user.id and not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Not allowed to post for this device")
    # Use provided timestamp or current time
    ts = payload.timestamp or datetime.utcnow()
    reading = Reading(device_id=payload.device_id, timestamp=ts, humidity=payload.humidity, temperature=payload.temperature, inclination=payload.inclination, rain=payload.rain, raw=payload.raw)
    session.add(reading)
    session.commit()
    session.refresh(reading)
    # Simple alert rule: humidity>80 or inclination>10
    alerts = []
    if payload.humidity is not None and payload.humidity > 80:
        alerts.append({"level": "warning", "message": "High humidity"})
    if payload.inclination is not None and payload.inclination > 10:
        alerts.append({"level": "danger", "message": "High inclination"})
    return {"reading_id": reading.id, "alerts": alerts}
