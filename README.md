# Islami 🕋

**Islami** is a high-performance, "High-level" digital companion for Muslims, engineered to surpass existing market leaders like WeMuslim. Built with a modular Flutter architecture and a high-speed FastAPI backend, it provides a seamless, ad-free, and premium experience as standard.

## 🚀 Vision
To provide the global Ummah with a sophisticated, visually stunning, and technically superior platform for daily spiritual practice, combining modern engineering with Islamic tradition.

## 🛠 Features

### 📱 Mobile (Android & iOS)
- **Precision Prayer Times:** GPS-accurate schedules using the `adhan` engine.
- **Quran Kareem:** Full Surah index with high-fidelity Arabic text, translations, and audio streaming.
- **Prayer Tracker:** Persistent SQL-based tracking system for daily prayer consistency.
- **Dynamic Qibla Compass:** Real-time orientation using device sensors.
- **Tasbih & Azkar:** Digital counters and categorized supplications for daily devotion.
- **Ummah Community:** Social layer for real-time engagement and community support.

### ⚙️ Backend (FastAPI)
- **High-Performance API:** Engineered with Python's FastAPI for low-latency data delivery.
- **Ummah Social Engine:** Centralized management for community posts and interactions.
- **Scalable Architecture:** Designed for rapid expansion and AI integration.

## 🏗 Tech Stack
- **Frontend:** Flutter (Dart) - *Primary Target: Android*
- **Backend:** FastAPI (Python)
- **Database:** SQLite (Local Persistence)
- **State Management:** BLoC / Provider
- **Networking:** Dio

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (v3.41.2+)
- Python (v3.14+)
- Android Studio / VS Code

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MemaroX/Islami.git
   cd Islami
   ```

2. **Setup Mobile (Android):**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

3. **Setup Backend:**
   ```bash
   cd backend
   python -m venv venv
   .\venv\Scripts\activate
   pip install -r requirements.txt
   python main.py
   ```

## 📜 License
© 2026 MixDarkoX Solutions. All rights reserved.

---
*Engineered by Maher & M.E.N.A.R.I CLI .*
