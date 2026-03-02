# My Headspace

My Headspace is a Flutter wellness journaling app with email authentication, onboarding flows, local-first journal storage, and cloud backup sync.

## Table of Contents
1. Project Overview
2. Features
3. Tech Stack
4. Architecture
5. Project Structure
6. Getting Started
7. Firebase Configuration
8. Running the App
9. Code Generation
10. Testing
11. Data Model Notes
12. Known Limitations
13. Useful Commands

## Project Overview
The app provides:
- User onboarding and account creation
- Firebase email/password authentication
- A protected app shell with tab navigation
- Rich-text journaling using Flutter Quill
- Local storage via Drift (SQLite)
- Optional cloud backup and automatic sync when connectivity returns

The codebase follows a feature-first structure with layered boundaries (`presentation`, `application`, `domain`, `data`) for core modules like `auth` and `journey`.

## Features
- Authentication:
  - Sign up, login, logout
  - Password reset and email verification screens
  - Auth state driven route guarding
- Journal:
  - Create/edit rich-text entries
  - Favorite/unfavorite entries
  - Local-first save behavior
  - Background sync for unsynced entries
- App shell:
  - Bottom tab navigation (`Home`, `Discovery`, `My Journey`, `More/Profile`)
- Personalization/profile screens (UI scaffolding in place)

## Tech Stack
- Framework: Flutter
- Language: Dart
- State management: `provider` (`ChangeNotifier`)
- Dependency injection: `get_it`
- Routing: `auto_route`
- Backend: Firebase Auth + Cloud Firestore
- Local database: Drift + SQLite (`drift_flutter`)
- Rich text editor: `flutter_quill`
- Connectivity sync trigger: `connectivity_plus`
- Responsive UI: `flutter_screenutil`

## Architecture
### App Bootstrap
- Entry point: `lib/main.dart`
- Root widget: `lib/app.dart`
- Service registration: `lib/service/service_locator.dart`

Bootstrap sequence:
1. Initialize Flutter bindings
2. Initialize Firebase (`firebase_options.dart`)
3. Register services/providers in `get_it`
4. Start app with `MultiProvider`
5. Start connectivity listener and attempt pending sync

### Navigation
- Router config: `lib/routes/app_route.dart`
- Generated routes: `lib/routes/app_route.gr.dart`
- Guard: `lib/routes/app_route_guard.dart`

Protected route behavior:
- `ApplicationNavigatorRoute` is guarded by `AuthGuard`
- Unauthenticated users are redirected to `GetStartedRoute`

### Auth Flow
- UI delegates to `AuthProvider`
- `AuthProvider` delegates to `AuthRepository`
- `AuthRepository` uses Firebase via `AuthRemoteDatasources`
- User profile fields are persisted to Firestore (`users` collection)

### Journal Flow
- UI writes through `JournalProvider`
- Provider calls use cases (`SaveJournal`, `GetAllJournals`, etc.)
- Use cases depend on domain `JournalRepository`
- `JournalRepositoryImpl` bridges:
  - Local datasource (Drift)
  - Cloud datasource (Firestore)

Local-first behavior:
- Entry is always saved locally first with `isBackedUp=false`
- Cloud backup is optional on save
- `syncPendingData()` uploads unsynced entries and marks them as backed up

## Project Structure
```text
lib/
  app.dart
  main.dart
  core/
    constants/
    utils/
  features/
    auth/
      application/
      data/
      domain/
      presentation/
    journey/
      application/
      data/
      domain/
      presentation/
    home/
    navigation/
    profile/
  routes/
    app_route.dart
    app_route.gr.dart
    app_route_guard.dart
    app_navigator.dart
  service/
    service_locator.dart
  shared/
    components/
    widgets/
  gen/
    assets.gen.dart
    colors.gen.dart
    fonts.gen.dart
```

## Getting Started
### Prerequisites
- Flutter SDK (project uses FVM and pins Flutter `3.38.3` in `.fvmrc`)
- Dart SDK compatible with the Flutter version
- Android Studio/Xcode (depending on target platform)
- Firebase project configured for your app IDs

### Install Dependencies
Using FVM (preferred):
```bash
fvm flutter pub get
```

Or system Flutter:
```bash
flutter pub get
```

## Firebase Configuration
Current Firebase wiring is already present:
- `lib/firebase_options.dart`
- `firebase.json`
- Expected native config outputs:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `macos/Runner/GoogleService-Info.plist`

If you need to regenerate config for a different Firebase project:
1. Install and login to FlutterFire CLI.
2. Run:
```bash
flutterfire configure
```

## Running the App
With FVM:
```bash
fvm flutter run
```

Without FVM:
```bash
flutter run
```

## Code Generation
This project uses generated code for:
- Routes (`auto_route`)
- Drift database files
- JSON/Freezed models
- Assets/colors/fonts (`flutter_gen`)

Run:
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode:
```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

Notes:
- `build.yaml` currently disables two `auto_route_generator` builder entries. If route generation does not update as expected, verify this config before troubleshooting imports.
- Generated files are committed (for example `lib/routes/app_route.gr.dart`, `lib/features/journey/data/local/database.g.dart`).

## Testing
Run all tests:
```bash
fvm flutter test
```

Current test coverage focus:
- Unit tests for auth providers and enums:
  - `test/unit-features/auth/...`
- Widget tests for auth/get-started/login:
  - `test/widget-features/auth/...`

Journal and sync paths currently have limited automated test coverage.

## Data Model Notes
### Journal fields
- `id`
- `title`
- `content` (Quill Delta JSON string)
- `createdAt`
- `color`
- `isFavourite`
- `isBackedUp`

### Local DB
- Table: `Journals` in `lib/features/journey/data/local/database.dart`
- DB file: `db.sqlite` in app documents directory

### Firestore paths
- Users: `users/{userId}`
- Journals: `users/{userId}/journals/{journalId}`

## Known Limitations
- `JourneyView` has a search text field UI, but no filtering logic yet.
- `getJournal(...)` in `JournalProvider` loads a journal but does not store it in state for later consumption.
- Cloud favorite toggle sync is currently disabled in repository code.
- Home/Discovery currently point to the same `HomeRoute`.
- Several TODOs and naming typos indicate active in-progress development.

## Useful Commands
```bash
# Environment
fvm flutter --version
fvm flutter doctor

# Dependencies
fvm flutter pub get

# Run
fvm flutter run

# Lint / analysis
fvm flutter analyze

# Format
fvm flutter format .

# Test
fvm flutter test

# Generate code
fvm flutter pub run build_runner build --delete-conflicting-outputs
```
