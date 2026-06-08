# 📝 Notely

> A clean, offline-first notes application built with Flutter and Dart.

---

## Overview

Notely is a mobile notes app designed for simplicity and speed. All notes are stored privately on the user's device — no account, no internet, no cloud. It was built as a personal productivity tool with a focus on clean UI and smooth user experience.

---

## Screenshots

> _Add screenshots to this section after building the APK._

---

## Features

- ✏️ Create, edit and delete notes
- 📌 Pin important notes to the top of the list
- 🎨 6 note background colour themes
- 🔍 Live search by title or content
- ⊞ Toggle between masonry grid and list view
- 💾 Fully offline — data persists across app restarts using local storage
- ℹ️ About screen with app credits

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| Local Storage | shared_preferences |
| Grid Layout | flutter_staggered_grid_view |
| Date Formatting | intl |
| ID Generation | uuid |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── note.dart              # Note data model + JSON serialisation
├── services/
│   └── notes_service.dart     # CRUD operations with SharedPreferences
├── screens/
│   ├── home_screen.dart       # Main dashboard, search, grid/list toggle
│   ├── editor_screen.dart     # Note creation and editing
│   └── about_screen.dart      # App info and credits
└── widgets/
    └── note_card.dart         # Reusable note card with pin/delete actions
```

---

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio (for Android SDK and emulator)
- VS Code with Flutter extension

### Installation

```bash
# 1. Create a new Flutter project
flutter create notely

# 2. Replace the lib/ folder and pubspec.yaml with the files from this repository

# 3. Install dependencies
cd notely
flutter pub get

# 4. Run on emulator or connected device
flutter run
```

### Build APK

```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Architecture

Notely follows a simple layered architecture:

- **Model** — defines the `Note` data structure and handles JSON serialisation/deserialisation
- **Service** — manages all read/write operations to local storage, abstracting SharedPreferences from the UI
- **Screens** — stateful widgets that handle UI logic and user interaction
- **Widgets** — reusable UI components separated from screen-level logic

---

## Data Storage

Notes are serialised to JSON and stored as a single string in SharedPreferences under the key `notes_data`. Each note carries an ID (UUID v4), title, content, timestamps, colour index, and pin status.

---

## Developer

**Israel Olukayode**
Built with Flutter & Dart
© 2025 Israel Olukayode. All rights reserved.
