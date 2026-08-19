from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from app.models import Device, User, get_session
from app.schemas import DeviceCreate, DeviceRead
from app.routes.auth import get_current_user
from typing import List

router = APIRouter()

@router.post("/", response_model=DeviceRead)
def create_device(device_in: DeviceCreate, current_user: User = Depends(get_current_user), session: Session = Depends(get_session)):
    device = Device(owner_id=current_user.id, name=device_in.name, model=device_in.model, latitude=device_in.latitude, longitude=device_in.longitude)
    session.add(device)
    session.commit()
    session.refresh(device)
    return device

@router.get("/", response_model=List[DeviceRead])
def list_devices(current_user: User = Depends(get_current_user), session: Session = Depends(get_session)):
    devices = session.exec(select(Device).where(Device.owner_id == current_user.id)).all()
    return devices
