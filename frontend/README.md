# 🌐 VersBottomLex.me Frontend

Flutter application for the VersBottomLex.me webcam platform.

## 📌 Overview

The VersBottomLex.me Frontend is built using Flutter for a cross-platform experience across web, Android, and iOS. The frontend serves as the user interface that interacts with the live streaming backend and provides features like chat, user engagement, and content management.

## 🎯 Features

- **High-quality Streaming**: Multi-camera support with RTSP streams
- **Real-time Chat**: Interactive chat interface for user engagement
- **Monetization**: Tipping system and private show functionality
- **Secure Authentication**: Biometric authentication with Flutter LocalAuth
- **Responsive Design**: Optimized UI for web, Android, and iOS

## ⚙️ Technologies Used

- **Flutter SDK** v3.19+ for frontend development
- **Material Design** for modern UI components
- **Provider** for state management
- **HTTP & WebSocket** for real-time communication
- **Flutter LocalAuth** for secure biometric login

## 📋 Architecture

The application follows a clean architecture approach with:
- UI layer built with Material Design
- State management using Provider
- Service layer for API interactions
- Repository pattern for data handling

## 🔧 Getting Started

### Prerequisites
- Flutter SDK v3.19+
- Dart SDK v3.0+

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/versbottomlex.me.git
   cd versbottomlex.me/frontend
   ```
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

## 📁 Folder Structure
```
lib/
├── config/        # App configuration
├── core/          # Core utilities and helpers
├── data/          # Data sources and repositories
├── models/        # Data models
├── providers/     # State management
├── presentation/  # UI screens and widgets
│   ├── screens/   # Application screens
│   └── widgets/   # Reusable widgets
├── services/      # Business logic
└── utils/         # Utility functions
```

## 🚀 Deployment
- Web: `flutter build web`
- Android: `flutter build apk`
- iOS: `flutter build ios`

## 💻 Development Notes

- The app includes routes for: splash, login, register, forgot password, home, profile, stream view, create stream, payment history, and settings
- The frontend is designed to handle multi-camera streams and can switch between them smoothly
- Ensure proper integration with the backend for real-time interactions like chat, tips, and show requests

## 🔮 Future Enhancements

- Implement AI-powered chat moderation for user safety
- Improve UI/UX based on user feedback
- Enhance performance for low-bandwidth connections