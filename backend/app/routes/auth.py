from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from app.models import get_session, User
from app.schemas import UserCreate, Token
from app.core.security import get_password_hash, verify_password, create_access_token, decode_access_token
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from fastapi import status
from typing import Optional

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

@router.post("/register", response_model=Token)
def register(user_in: UserCreate):
    with Session() as session:
        existing = session.exec(select(User).where(User.email == user_in.email)).first()
        if existing:
            raise HTTPException(status_code=400, detail="Email already registered")
        user = User(email=user_in.email, full_name=user_in.full_name, hashed_password=get_password_hash(user_in.password))
        session.add(user)
        session.commit()
        session.refresh(user)
        token = create_access_token({"sub": str(user.id)})
        return {"access_token": token, "token_type": "bearer"}

@router.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    with Session() as session:
        user = session.exec(select(User).where(User.email == form_data.username)).first()
        if not user or not verify_password(form_data.password, user.hashed_password):
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect credentials")
        token = create_access_token({"sub": str(user.id)})
        return {"access_token": token, "token_type": "bearer"}

from fastapi import Security

def get_current_user(token: str = Depends(oauth2_scheme)) -> User:
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid token")
    user_id = int(payload.get("sub"))
    with Session() as session:
        user = session.get(User, user_id)
        if not user:
            raise HTTPException(status_code=401, detail="User not found")
        return user
