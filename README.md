# Flutter Quiz App with Local Leaderboard

A mobile quiz application built in Flutter with **LaTeX support** for math/science questions, an offline **local leaderboard**, and persistent storage.
Developed as part of the **Senior Flutter Developer** technical assignment for **RubizCode**.

---

## Features

### Core

* **Home Screen** – Start Quiz & View Leaderboard
* **Quiz Flow** – Loads from local `questions.json`, LaTeX rendering, progress indicator, one question at a time
* **Results Screen** – Shows final score, lets user enter player name, saves to leaderboard
* **Leaderboard Screen** – Displays sorted scores (highest first), persistent storage

### Implementation Details

* Works entirely **offline** (local assets & SQLite)
* **LaTeX rendering** via `flutter_math_fork`
* **State Management** with `Provider`
* **Persistent Storage** with `sqflite`
* Clean, responsive UI

---

## Tech Stack

| Package                     | Purpose              |
| --------------------------- | -------------------- |
| `provider: ^6.1.5`          | State management     |
| `flutter_math_fork: ^0.7.4` | LaTeX rendering      |
| `sqflite: ^2.4.2`           | SQLite storage       |
| `path: ^1.9.1`              | Path handling for DB |

---

## Project Structure

```
lib/
 ├── main.dart              # Entry point
 ├── models/                # Data models (Question, ScoreEntry)
 ├── providers/             # State management providers
 ├── screens/               # Home, Quiz, Results, Leaderboard screens
 ├── widgets/               # Reusable UI widgets
assets/
 └── questions.json         # Local quiz data
```

---

## Setup & Run Instructions

### 1 Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (Stable channel, version `X.Y.Z` used for this project)
* Android Studio / VS Code with Flutter plugin

### 2 Installation

```bash
git clone <repository-url>
cd <project-folder>
flutter pub get
```

### 3 Run on Device/Emulator

```bash
flutter run
```

### 4 Build Release APK

```bash
flutter build apk --release
```

The release APK will be available at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Architecture Overview

The app follows a **Provider-based state management architecture**:

1. **UI Layer** – Flutter widgets in `screens` & `widgets`
2. **State Layer** – `QuizProvider` and `LeaderboardProvider` hold quiz progress and leaderboard data
3. **Data Layer** –

    * **Local JSON Loader** for questions (`assets/questions.json`)
    * **SQLite Database** for persistent leaderboard storage

---

## ✅ Implemented

* All **MVP features** from assignment requirements:

    * LaTeX rendering for questions and answers
    * Persistent leaderboard
    * Clean UI
    * Works offline
* GitHub Actions CI for:

    * `flutter analyze`
    * `flutter test`

---

## Sample `questions.json`

```json
[
  {
    "question": "What is the capital of France?",
    "options": ["Paris", "London", "Rome", "Berlin"],
    "answer_index": 0
  },
  {
    "question": "Evaluate the integral: $$ \\int_0^1 x^2 dx $$",
    "options": ["1/2", "1/3", "2/3", "1"],
    "answer_index": 1
  }
]
```

---

## Continuous Integration

This project includes **GitHub Actions CI** (`.github/workflows/flutter_ci.yml`):

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

---

## Demo (Optional)



---

**Author:** Muntasir Efaz
**License:** MIT

---