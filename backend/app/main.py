from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import auth, devices, telemetry
from app.core.config import settings
from app.models import create_db_and_tables

app = FastAPI(title="GeoGuardian Backend")

# CORS (useful for Flutter web during development). Configure via CORS_ORIGINS env var.
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def on_startup():
    create_db_and_tables()

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(devices.router, prefix="/devices", tags=["devices"])
app.include_router(telemetry.router, prefix="/telemetry", tags=["telemetry"])

@app.get("/health")
def health():
    return {"status": "ok"}
