from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import jwt

# Dummy user
FAKE_USER_DB = {
    "admin": {
        "username": "admin",
        "hashed_password": "$2b$12$7RF0fDHRv8K64XGc2b.mZegGYRxmx3eXVnzg4nLBK4szmyZTZINGS"  # password: admin123
    }
}

SECRET_KEY = "codexionsecret"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain, hashed):
    return pwd_context.verify(plain, hashed)

def get_user(username: str):
    return FAKE_USER_DB.get(username)

def authenticate_user(username: str, password: str):
    user = get_user(username)
    if not user or not verify_password(password, user['hashed_password']):
        return None
    return user

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
