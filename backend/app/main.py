from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from typing import List, Dict
from pydantic import BaseModel
import json
import os

app = FastAPI(title="Islami Pro Command Center")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

ACTIVITY_FILE = "activity_data.json"

def load_activity():
    if os.path.exists(ACTIVITY_FILE):
        with open(ACTIVITY_FILE, "r") as f:
            try:
                return json.load(f)
            except:
                return {}
    return {}

def save_activity(data):
    with open(ACTIVITY_FILE, "w") as f:
        json.dump(data, f)

class SyncRecord(BaseModel):
    date: str
    prayer_name: str
    is_prayed: bool

@app.get("/", response_class=HTMLResponse)
async def dashboard():
    return """
    <!DOCTYPE html>
    <html lang="ar" dir="rtl">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>إسلامي | لوحة التحكم</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;700&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Tajawal', sans-serif; background-color: #f8fafc; }
            .islamic-green { background-color: #004D40; }
            .accent-gold { color: #FFD700; }
        </style>
    </head>
    <body class="p-8">
        <div class="max-w-6xl mx-auto">
            <header class="flex justify-between items-center mb-12 islamic-green p-8 rounded-3xl shadow-2xl text-white">
                <div>
                    <h1 class="text-4xl font-bold mb-2">إسلامي <span class="accent-gold">PRO</span></h1>
                    <p class="text-emerald-100 text-lg">مركز القيادة والتحكم في النشاط الروحي</p>
                </div>
                <button onclick="loadActivity()" class="bg-white text-emerald-900 px-8 py-3 rounded-2xl font-bold hover:bg-emerald-50 transition-all shadow-lg">تحديث البيانات</button>
            </header>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                <div class="bg-white p-8 rounded-3xl shadow-sm border border-emerald-50">
                    <h3 class="text-slate-500 mb-2 font-bold uppercase tracking-wider">إجمالي السجلات</h3>
                    <p id="totalRecords" class="text-5xl font-bold text-emerald-900">0</p>
                </div>
                <div class="bg-white p-8 rounded-3xl shadow-sm border border-emerald-50">
                    <h3 class="text-slate-500 mb-2 font-bold uppercase tracking-wider">الصلوات المكتملة</h3>
                    <p id="completedPrayers" class="text-5xl font-bold text-emerald-600">0</p>
                </div>
                <div class="bg-white p-8 rounded-3xl shadow-sm border border-emerald-50">
                    <h3 class="text-slate-500 mb-2 font-bold uppercase tracking-wider">نسبة الالتزام</h3>
                    <p id="commitmentRate" class="text-5xl font-bold text-amber-500">0%</p>
                </div>
            </div>

            <div class="bg-white rounded-3xl shadow-sm border border-emerald-50 overflow-hidden">
                <div class="p-8 border-b border-slate-100 flex justify-between items-center">
                    <h2 class="text-2xl font-bold text-slate-800">سجل النشاط التفصيلي</h2>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-right">
                        <thead class="bg-slate-50">
                            <tr>
                                <th class="p-6 text-slate-600 font-bold">التاريخ</th>
                                <th class="p-6 text-slate-600 font-bold">الصلاة</th>
                                <th class="p-6 text-slate-600 font-bold">الحالة</th>
                            </tr>
                        </thead>
                        <tbody id="activityTable" class="divide-y divide-slate-100">
                            <!-- Data injected here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            async function loadActivity() {
                const response = await fetch('/activity');
                const data = await response.json();
                
                const table = document.getElementById('activityTable');
                table.innerHTML = '';
                
                let total = 0;
                let completed = 0;
                
                // Sort keys by date descending
                const sortedKeys = Object.keys(data).sort().reverse();

                sortedKeys.forEach(key => {
                    const [date, prayer] = key.split('_');
                    const isPrayed = data[key];
                    total++;
                    if(isPrayed) completed++;

                    const row = `
                        <tr class="hover:bg-slate-50 transition-colors">
                            <td class="p-6 font-medium text-slate-700">${date}</td>
                            <td class="p-6 text-slate-700">${prayer}</td>
                            <td class="p-6">
                                <span class="${isPrayed ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'} px-4 py-1.5 rounded-full text-sm font-bold">
                                    ${isPrayed ? 'تمت الصلاة' : 'لم تتم'}
                                </span>
                            </td>
                        </tr>
                    `;
                    table.innerHTML += row;
                });

                document.getElementById('totalRecords').innerText = total;
                document.getElementById('completedPrayers').innerText = completed;
                document.getElementById('commitmentRate').innerText = total > 0 ? Math.round((completed / total) * 100) + '%' : '0%';
            }

            loadActivity();
        </script>
    </body>
    </html>
    """

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
