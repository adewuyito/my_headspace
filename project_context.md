# Project Context: My Headspace

## 1. Project Overview
**My Headspace** is a Flutter-based wellness journaling application. It is designed to provide users with a private, seamless journaling experience emphasizing local-first storage with eventual cloud synchronization.

## 2. Technology Stack
- **Framework:** Flutter (using FVM, pinned to version 3.38.3)
- **Language:** Dart
- **State Management:** `provider` (using `ChangeNotifier`)
- **Dependency Injection:** `get_it`
- **Routing:** `auto_route`
- **Local Database:** `drift` (SQLite) with `drift_flutter`
- **Backend / Cloud Services:** Firebase Auth & Cloud Firestore
- **Rich Text Editor:** `flutter_quill`
- **Code Generation:** `freezed`, `json_serializable`, `drift_dev`, `auto_route_generator`, `flutter_gen`

## 3. Architecture Structure
The application follows a **feature-first, layered architecture**.
Key directories in `lib/`:
- `core/`: Constants, extensions, utilities.
- `features/`: Contains the main domains of the app (`auth`, `journey`, `home`, `navigation`, `onboarding`, `profile`).
- `routes/`: Centralized routing configuration (`app_route.dart`, `app_route_guard.dart`).
- `service/`: Service locator setup (`service_locator.dart`).
- `shared/`: Reusable UI components and widgets.

**Feature Layering:**
Inside complex features (like `auth` and `journey`), the code is divided into:
- `presentation/`: UI screens, widgets, and state providers.
- `application/`: Application logic, use cases.
- `domain/`: Business rules, entities, and repository interfaces.
- `data/`: Data models (DTOs), local/remote data sources, and concrete repository implementations.

## 4. Key Workflows & Engineering Intent

### Local-First Journal Synchronization
As defined in `intent.md`, the app prioritizes UX speed by making saving operations non-blocking:
1. **Local Save (UI-Critical):** When a user saves a journal or navigates back, the entry is immediately saved to the local Drift database with a flag `isBackedUp = false`. The UI pops immediately without waiting for a network request.
2. **Background Sync:** A background process (Outbox pattern) reads local entries where `isBackedUp = false` and attempts to upload them to Firestore.
3. **Eventual Consistency:** On successful upload, the local entry is updated to `isBackedUp = true`. If it fails, it remains pending and retries later.

### Navigation and Authentication
- Handled by `auto_route`.
- An `AuthGuard` checks the authentication state. If a user is not authenticated, they are blocked from accessing the `ApplicationNavigatorRoute` and redirected to the `GetStartedRoute`.
- Firebase Auth handles the actual credentials and sessions, while user profile data is mirrored in the Firestore `users/{userId}` collection.

## 5. Data Models
### Journal Entry
- `id`: Unique identifier
- `title`: String
- `content`: Rich-text data (stored as Quill Delta JSON string)
- `createdAt`: Timestamp
- `color`: String/Int
- `isFavourite`: Boolean
- `isBackedUp`: Boolean (Source of truth for cloud sync status)

### Firestore Paths
- Users: `users/{userId}`
- Journals: `users/{userId}/journals/{journalId}`

## 6. Known Limitations & TODOs
- **Search:** `JourneyView` has a search UI but no actual filtering logic is implemented yet.
- **Sync:** Cloud favorite toggle synchronization is currently disabled.
- **Routing:** Home and Discovery tabs currently point to the same `HomeRoute`.
- **Test Coverage:** Currently focused on Auth unit/widget tests. Journaling and sync paths need more automated test coverage.
- **Development Status:** The codebase has several active TODOs indicating ongoing work on the synchronization and caching layers.

## 7. Essential Commands
```bash
# Setup dependencies (Using FVM is preferred)
fvm flutter pub get

# Run code generation
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
fvm flutter run

# Run tests
fvm flutter test
```
