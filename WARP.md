# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Flutter-based mobile application called "my_headspace" using Flutter 3.35.3 (managed via FVM). The project appears to be a personal development or social connection app with features for onboarding, authentication, profile setup, and user interactions.

## Essential Commands

### Flutter Version Management
This project uses FVM (Flutter Version Manager) to manage Flutter versions:
- **Get correct Flutter version**: `fvm flutter --version`
- **Run any flutter command**: Prefix with `fvm`, e.g., `fvm flutter run`

### Building and Running
- **Run app (development)**: `fvm flutter run`
- **Build for iOS**: `fvm flutter build ios`
- **Build for Android**: `fvm flutter build apk` or `fvm flutter build appbundle`
- **Build for macOS**: `fvm flutter build macos`
- **Clean build artifacts**: `fvm flutter clean`
- **Get dependencies**: `fvm flutter pub get`

### Code Generation
The project uses code generation for routing (auto_route) and assets (flutter_gen):
- **Generate all code**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- **Watch for changes**: `fvm flutter pub run build_runner watch --delete-conflicting-outputs`
- **Generate colors from XML**: Handled automatically by `flutter_gen` (configured in pubspec.yaml)

**Important**: The file `lib/routes/cuddle_router.gr.dart` is referenced in code but not yet generated. Run the build_runner command above to generate it.

### Code Quality
- **Analyze code**: `fvm flutter analyze`
- **Format code**: `fvm flutter format .`
- **Run lints**: `fvm flutter analyze` (uses flutter_lints package)

### Testing
- **Run all tests**: `fvm flutter test`
- **Run specific test**: `fvm flutter test test/path/to/test_file.dart`
- **Run tests with coverage**: `fvm flutter test --coverage`

Note: There are currently no test files in the project.

## Architecture

### Project Structure
```
lib/
├── core/               # Shared utilities, constants, and themes
│   └── constants/      # App theme, text theme, and styles
├── features/           # Feature-based modules
│   ├── auth/          # Authentication logic and providers
│   ├── home/          # Home screen
│   ├── journey/       # Journey-related features
│   ├── onboarding/    # Onboarding flow
│   └── profile/       # User profile features
├── gen/               # Auto-generated code (colors, assets)
├── routes/            # Navigation configuration
│   ├── app_route.dart       # Route definitions using auto_route
│   ├── app_route_guard.dart # Authentication guards
│   └── app_navigator.dart   # Navigation utilities
├── service/           # Service layer
│   └── service_locator.dart # Dependency injection with get_it
├── app.dart          # Root application widget
└── main.dart         # Application entry point
```

### Key Architectural Patterns

**Dependency Injection**: Uses `get_it` for service location
- All services are registered in `lib/service/service_locator.dart`
- Access services via `serviceLocator.getIt<ServiceType>()`
- To add a new service: register it as singleton or factory in `ServiceLocator.configure()`

**State Management**: Uses `provider` package
- Providers are registered in `main.dart` using `MultiProvider`
- Example: `AuthProvider` is a `ChangeNotifier` for auth state
- To add a new provider: create a `ChangeNotifier` class and register in `main.dart`

**Routing**: Uses `auto_route` for declarative navigation
- Routes defined in `lib/routes/app_route.dart` using `@AutoRouterConfig`
- Router class is `CuddleRouter` with fade transitions
- Uses `AuthGuard` for protected routes
- Nested routing supported (e.g., profile setup flow, dashboard)
- **Important**: After adding new routes/screens, run code generation

**UI Responsiveness**: Uses `flutter_screenutil`
- Design size: 402 x 874 (configured in `app.dart`)
- Use `.w`, `.h`, `.sp` extensions for responsive sizing

**Theming**: Centralized theme in `lib/core/constants/app_theme.dart`
- Colors generated from `assets/app_colors.xml` → `lib/gen/colors.gen.dart`
- Access colors via `ColorName.colorName` (e.g., `ColorName.primary`)
- To add colors: update `assets/app_colors.xml` and regenerate

### Navigation Flow
The app has several distinct flows defined in routing:
1. **Onboarding/Auth Flow**: Splash → Account Creation → LinkedIn Auth → Profile Creation
2. **Profile Setup Flow**: Multi-step nested routing at `/profile_setup` with steps for preferences, age, interests, gender, sexuality, dating interests, and photos
3. **Dashboard**: Bottom navigation with Explore, Like, Chat, Profile tabs
4. **Profile Management**: Privacy settings (`/profile_privacy`) and bio setup (`/profile_bio`)

All routes use fade transitions by default (400ms), with some using slide-left transitions.

## Development Notes

### Adding a New Feature
1. Create a new directory under `lib/features/`
2. Structure: typically includes `data/` (providers/models) and `presentation/` (UI)
3. Register any providers in `service/service_locator.dart` if needed
4. Add routes in `lib/routes/app_route.dart`
5. Run `fvm flutter pub run build_runner build --delete-conflicting-outputs` to generate routes

### Working with Colors
- All colors defined in `assets/app_colors.xml`
- Auto-generated to `lib/gen/colors.gen.dart` by flutter_gen
- Use format: `<color name="colorName">#HEXVALUE</color>` in XML
- After modifying colors, run `fvm flutter pub get` to regenerate

### Common Issues
- **Missing generated files**: Run `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- **Import errors for routes**: Ensure `cuddle_router.gr.dart` is generated
- **Riverpod imports in routing**: Note that `app_route.dart` uses `hooks_riverpod` but main app uses `provider` - this appears to be in transition
- **FVM not found**: Install with `dart pub global activate fvm` or use system Flutter

### Dependencies Overview
- **State Management**: provider (primary), hooks_riverpod (in routing only)
- **DI**: get_it
- **Routing**: auto_route with auto_route_generator
- **UI**: flutter_screenutil for responsive design
- **Code Gen**: flutter_gen for assets/colors, lean_builder (purpose unclear from codebase)
