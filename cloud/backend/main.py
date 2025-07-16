from fastapi import FastAPI
from apps.cxsun.auth.routes import router as auth_router

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Codexion backend running"}

app.include_router(auth_router)
