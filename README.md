# Multiplayer Flutter Chess Game  

A modern **real-time multiplayer chess game** built with **Flutter**, **Supabase**, and the **Bishop Chess Engine** — featuring elegant design, smooth animations, and real-time synchronization using **Forsyth–Edwards Notation (FEN)**.  

---

## 🚀 Overview  

![Gameplay Preview](/assets/chess.gif)



This project delivers a polished **cross-platform chess experience** that is both fast and scalable.  

### Key Features  
- 🕹️ **Local Multiplayer** — Play with a friend on the same device  
- 🌐 **Online Multiplayer** — Real-time sync powered by Supabase  
- 🤖 **Single-Player Mode** — Battle against an AI opponent  
- ⚡ **Offline Support** — Continue playing even without connection  
- 🎨 **Dynamic Theming** — Light and dark modes with seamless switching  
- 🎉 **Win Confetti Animations**  
- 🔊 **Move Sound Effects**  
- 🌍 **Localization Support** *(English/Arabic planned)*  

---

## 🧩 Architecture Overview  

The application is structured around a **modular and scalable architecture** using **GetX** for state management and **Supabase** for real-time data handling.  

### 🏗️ Project Structure  
```
lib/
│
├── core/
│   ├── app/
│   │   ├── controller/       → Global app controller (theme, connection, localization)
│   │   ├── theme/            → Light and Dark theme configurations
│   │
│   ├── constants/            → App colors, utilities, helpers, etc.
│   ├── services/             → Supabase integration, caching, networking utilities
│
├── presentation/
│   ├── features/
│   │   ├── game_menu/        → Main menu and navigation
│   │   ├── game_board/       → Board UI, move logic, animations
│   │   ├── single_player/    → AI and offline gameplay logic
│   │   ├── multiplayer/      → Real-time FEN synchronization with Supabase
│   │   ├── settings/         → Themes, localization, and preferences
│   │   ├── about_us/         → Developer information and links
│   │   └── options/          → Game mode and board options
│   │
│   ├── widgets/              → Reusable UI components (buttons, dialogs, etc.)
│
└── main.dart                 → Entry point, Supabase setup, theme binding
```

---

## 💡 Why Supabase?  

Supabase acts as the **backend engine** for real-time gameplay and future scalability.  

It provides:  
- 🗄️ **PostgreSQL Database** — Game rooms and user sessions  
- ⚡ **Realtime API** — Instant move synchronization between players  
- 🔐 **Authentication System** *(planned)*  
- 🧱 **Storage** — Player stats, profile pictures, and match history  

---

## ♻️ Real-Time Gameplay with FEN  

### 🎯 About FEN  
**FEN (Forsyth–Edwards Notation)** represents the state of a chess board in a single line of text.  

Example:
```
rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
```

It includes:
- Piece placement  
- Active color  
- Castling rights  
- En passant target square  
- Move counters  

This enables **accurate, lightweight board synchronization** between two remote players.  

---

## ♜ Chess Board (ASCII Representation)  

### 🧱 Example FEN → ASCII  

```
r n b q k b n r
p p p p p p p p
. . . . . . . .
. . . . . . . .
. . . . . . . .
. . . . . . . .
P P P P P P P P
R N B Q K B N R
```

| Flag | Meaning |
|------|----------|
| `n`  | Normal move |
| `b`  | Big pawn move (2 squares) |
| `e`  | En passant capture |
| `c`  | Capture |
| `k`  | Kingside castle |
| `q`  | Queenside castle |
| `p`  | Promotion |

| Piece | Symbol |
|--------|---------|
| Pawn | `p` |
| Knight | `n` |
| Bishop | `b` |
| Rook | `r` |
| Queen | `q` |
| King | `k` |

---

## 🧠 Gameplay Modes  

- **Local Play:**  
  Start a chess match with a friend on the same device.  

- **AI Mode:**  
  Challenge a simple AI opponent using legal move generation (to be upgraded with Minimax in future).  
  ```dart
  withBot(goToSinglePlayer(bot: true));
  ```

---

## 🧭 Planned Features  

| Status | Feature |
|:-------:|----------|
| ✅ | Online/Offline auto detection |
| ✅ | Move sounds |
| ✅ | Win/Draw detection |
| ✅ | QR code room joining |
| 🕐 | Splash & loading screens |
| 🕐 | User authentication |
| 🕐 | Points system for unlocking themes |
| 🕐 | Spectator mode |
| 🕐 | Full localization (EN/AR) |

---

## 🧱 Tech Stack  

| Category | Tool |
|-----------|------|
| **Frontend** | Flutter |
| **State Management** | GetX |
| **Backend** | Supabase (Realtime + PostgreSQL) |
| **Chess Logic** | Bishop Chess Engine |
| **Board Coordinates** | Square package |
| **Local Storage** | SharedPreferences |
| **Logging** | Logger |
| **Responsive UI** | flutter_screenutil |

---

## 🏁 Getting Started  

### ⚡ Run Locally  
```bash
git clone https://github.com/YahieaDada/chess_game.git
cd chess_game
flutter pub get
flutter run
```

---

## 👨‍💻 Developer  

**Yahiea Dada**  
🎓 Computer Science Student  
💼 Passionate about Flutter, Real-time Apps, and Game Development  
🔗 [GitHub](https://github.com/YahieaDada) | [LinkedIn](https://linkedin.com/in/YahieaDada)

---

> _Built with Flutter, Supabase, Bishop, and passion for clean architecture and elegant design._
