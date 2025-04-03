# VersBottomLex.me Frontend

Flutter application for the VersBottomLex.me webcam platform.

## Features

- High-quality streaming with multi-camera support
- Interactive chat interface
- Tipping and private show functionality
- Biometric authentication with Flutter LocalAuth
- Responsive UI for web, Android, and iOS

## Architecture

The application follows a clean architecture approach with:
- UI layer built with Material Design
- State management using Provider
- Service layer for API interactions
- Repository pattern for data handling

## Getting Started

### Prerequisites
- Flutter SDK v3.19+
- Dart SDK v3.0+

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure your environment variables (see `.env.example`)

### Running the App
```bash
# Run in debug mode
flutter run

# Run for web
flutter run -d chrome

# Run for specific device
flutter run -d <device_id>
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

## Folder Structure
```
lib/
├── config/        # App configuration
├── core/          # Core utilities and helpers
├── data/          # Data sources and repositories
├── models/        # Data models
├── providers/     # State management
├── screens/       # UI screens
├── services/      # Business logic
├── utils/         # Utility functions
└── widgets/       # Reusable widgets
```

## Deployment
- Web: `flutter build web`
- Android: `flutter build apk`
- iOS: `flutter build ios`
