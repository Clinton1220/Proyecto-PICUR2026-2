from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class UserCreate(BaseModel):
    email: str
    password: str
    full_name: Optional[str] = None

class UserRead(BaseModel):
    id: int
    email: str
    full_name: Optional[str]

class DeviceCreate(BaseModel):
    name: str
    model: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None

class DeviceRead(BaseModel):
    id: int
    owner_id: int
    name: str
    model: Optional[str]

class TelemetryCreate(BaseModel):
    device_id: int
    timestamp: Optional[datetime] = None
    humidity: Optional[float] = None
    temperature: Optional[float] = None
    inclination: Optional[float] = None
    rain: Optional[float] = None
    raw: Optional[str] = None
