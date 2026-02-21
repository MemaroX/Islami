from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Dict
from pydantic import BaseModel
import json
import os

app = FastAPI(title="Islami Pro API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Persistence for activity records
ACTIVITY_FILE = "activity_data.json"

def load_activity():
    if os.path.exists(ACTIVITY_FILE):
        with open(ACTIVITY_FILE, "r") as f:
            return json.load(f)
    return {}

def save_activity(data):
    with open(ACTIVITY_FILE, "w") as f:
        json.dump(data, f)

class SyncRecord(BaseModel):
    date: str
    prayer_name: str
    is_prayed: bool

@app.get("/")
async def root():
    return {"status": "operational", "message": "Islami Pro Command Center Operational"}

@app.post("/sync")
async def sync_activity(records: List[SyncRecord]):
    current_data = load_activity()
    for rec in records:
        key = f"{rec.date}_{rec.prayer_name}"
        current_data[key] = rec.is_prayed
    save_activity(current_data)
    return {"status": "success", "message": f"Synced {len(records)} records"}

@app.get("/activity")
async def get_activity():
    return load_activity()

@app.get("/ummah/posts")
async def get_ummah_posts():
    return [
        {"id": 1, "author": "Ahmed", "content": "Subhan Allah, the Quran is a guide for all humanity.", "likes": 42},
        {"id": 2, "author": "Fatima", "content": "May Allah bless our Ummah.", "likes": 128},
    ]
