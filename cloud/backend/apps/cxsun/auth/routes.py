from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from jose import JWTError, jwt
from .schemas import LoginRequest, TokenResponse, User
from .service import authenticate_user, create_access_token, get_user, SECRET_KEY, ALGORITHM

router = APIRouter(prefix="/auth", tags=["auth"])

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

@router.post("/login", response_model=TokenResponse)
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_access_token({"sub": user['username']})
    return {"access_token": token, "token_type": "bearer"}

@router.get("/me", response_model=User)
def read_users_me(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        user = get_user(username)
        if not user:
            raise HTTPException(status_code=401, detail="Invalid token")
        return {"username": user["username"]}
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
