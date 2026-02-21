from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from pydantic import BaseModel

app = FastAPI(title="Islami API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"status": "operational", "message": "Welcome to Islami Pro API"}

# Ummah Community (Stub)
class Post(BaseModel):
    id: int
    author: str
    content: str
    likes: int

@app.get("/ummah/posts", response_model=List[Post])
async def get_ummah_posts():
    return [
        {"id": 1, "author": "Ahmed", "content": "Subhan Allah, the Quran is a guide for all humanity.", "likes": 42},
        {"id": 2, "author": "Fatima", "content": "May Allah bless our Ummah.", "likes": 128},
    ]

# Prayer Times (Stub)
@app.get("/prayer-times")
async def get_prayer_times(lat: float, lon: float):
    return {
        "fajr": "05:12 AM",
        "dhuhr": "12:15 PM",
        "asr": "03:45 PM",
        "maghrib": "06:20 PM",
        "isha": "07:45 PM"
    }
