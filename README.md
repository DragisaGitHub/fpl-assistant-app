# FPL Assistant Lite (App)

A lightweight Fantasy Premier League (FPL) mobile assistant for tracking **deadlines, player availability, price changes, and your personal watchlist**.  
Built with **Flutter** for Android & iOS.

---

## ✨ Features (MVP Scope)
- 📅 **Deadlines** – countdown to the next Gameweek, with local notifications (24h / 3h / 30min before deadline).  
- 🩺 **Injuries & Suspensions** – quick overview of player statuses.  
- 💰 **Price Tracking** – up-to-date player values.  
- ⭐ **Watchlist** – add/remove players and see their upcoming fixtures (with "green run" indicator).  

---

## 🔮 Roadmap
- **v0.1 (MVP)**: Deadlines, notifications, player list, watchlist.  
- **v0.2**: Price change history and trends.  
- **v0.3**: Sync with backend (optional login), multi-device support.  
- **v0.4**: Basic recommendation engine (form + fixtures).  
- **v1.0**: Push notifications from server (price rises, injury news).  

---

## 🛠 Tech Stack
- **Frontend**: Flutter, Riverpod, GoRouter, Dio, Isar, flutter_local_notifications.  
- **Backend (planned)**: Java 21, Spring Boot 3 (WebFlux), R2DBC + Postgres (for sync and advanced features).  
- **CI/CD**: GitHub Actions (lint, test, build).  

---

## 📦 Getting Started
```bash
flutter pub get
flutter run
