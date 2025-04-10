# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository for the VersBottomLex.me webcam platform.

## Project Overview

VersBottomLex.me is an adult webcam streaming platform featuring:
- High-quality multi-camera live streaming (RTSP)
- Secure payment systems with cryptocurrency support
- Biometric authentication
- Interactive features (tipping, private shows)
- Cross-platform support (Web, iOS, Android)

## Repository Structure

```
/
├── frontend/           # Flutter-based frontend
│   ├── lib/            # Main Flutter source code
│   │   ├── screens/    # UI screens
│   │   ├── widgets/    # Reusable UI components
│   │   ├── models/     # Data models
│   │   ├── services/   # API services & business logic
│   │   ├── utils/      # Helper functions & utilities
│   │   └── main.dart   # Application entry point
│   ├── assets/         # Static assets (images, fonts)
│   └── test/           # Frontend tests
├── backend/            # Node.js/Express backend
│   ├── src/            # Server source code
│   │   ├── controllers/  # Request handlers
│   │   ├── models/     # Database models
│   │   ├── routes/     # API route definitions
│   │   ├── services/   # Business logic
│   │   ├── utils/      # Helper functions
│   │   └── app.js      # Express application
│   ├── config/         # Configuration files
│   └── test/           # Backend tests
├── docs/               # Documentation
└── docker/             # Docker configuration
```

## Build & Test Commands

### Frontend (Flutter)
- Setup: `cd frontend && flutter pub get`
- Build web: `cd frontend && flutter build web`
- Build Android: `cd frontend && flutter build apk --release`
- Build iOS: `cd frontend && flutter build ios --release`
- Run: `cd frontend && flutter run`
- Analyze: `cd frontend && flutter analyze`
- Test all: `cd frontend && flutter test`
- Test single: `cd frontend && flutter test test/path/to/test.dart`
- Format: `cd frontend && dart format lib/`
- Clean: `cd frontend && flutter clean`
- Generate localizations: `cd frontend && flutter gen-l10n`

### Backend (Node.js)
- Setup: `cd backend && npm install`
- Start server: `cd backend && npm start`
- Development mode: `cd backend && npm run dev`
- Test: `cd backend && npm test`
- Test with coverage: `cd backend && npm run test:coverage`
- Lint: `cd backend && npm run lint`
- Fix linting issues: `cd backend && npm run lint:fix`
- Type check: `cd backend && npm run typecheck`
- Build: `cd backend && npm run build`

### Docker
- Build containers: `docker-compose build`
- Start services: `docker-compose up`
- Stop services: `docker-compose down`
- Rebuild and start: `docker-compose up --build`

## Environment Setup

### Frontend
- Flutter SDK v3.19+
- Dart SDK 3.0+
- Required extensions for VS Code:
  - Flutter
  - Dart
  - Flutter Intl

### Backend
- Node.js v18+
- npm v9+
- PostgreSQL v14+

### Environment Variables
- Frontend: Located in `.env` file
- Backend: Located in `.env` file
- Example format:
  ```
  # Backend
  PORT=3000
  DATABASE_URL=postgres://user:password@localhost:5432/verslex
  JWT_SECRET=your-jwt-secret
  STRIPE_API_KEY=your-stripe-key
  
  # Frontend
  API_URL=http://localhost:3000/api
  STREAM_URL=rtsp://stream-server:8554/
  ```

## Code Style Guidelines

### Flutter/Dart
- Use `const` constructors whenever possible
- Prefer named parameters for widgets and functions
- Follow standard Flutter widget naming: `MyWidget`, `_MyWidgetState`
- Type all variables and parameters
- Use `required` keyword for mandatory parameters
- Import organization:
  1. dart:core packages
  2. package:flutter packages
  3. Third-party packages
  4. Project imports (with relative paths)
- Error handling: Use try/catch blocks with specific exceptions
- Use `context.read<T>()` for one-time provider access and `context.watch<T>()` for reactive UI updates
- Widgets should be broken down into smaller, reusable components
- Utilize extension methods for cleaner code
- Use private members (`_memberName`) for implementation details

### Backend (Node.js/Express)
- Use camelCase for variables and functions
- Use PascalCase for classes
- Use meaningful variable and function names
- Group related functionality in modules
- Document API endpoints with JSDoc
- Use async/await over Promises
- Implement proper error handling with custom error classes
- Validate input data before processing
- Use environment variables for configuration
- Keep controllers lean, move business logic to services
- Follow RESTful conventions for API endpoints
- Use transactions for database operations when appropriate

## Database Schema

### Key Tables
- `users`: User authentication and profile data
- `streams`: Stream metadata and configuration
- `transactions`: Payment and tipping records
- `subscriptions`: User subscription data
- `chat_messages`: Live chat history

## API Documentation

### Authentication Endpoints
- `POST /api/auth/register`: Create new user account
- `POST /api/auth/login`: Authenticate user
- `POST /api/auth/refresh-token`: Refresh authentication token
- `POST /api/auth/logout`: Logout user

### Stream Endpoints
- `GET /api/streams`: List available streams
- `GET /api/streams/:id`: Get stream details
- `POST /api/streams`: Create new stream (admin)
- `PUT /api/streams/:id`: Update stream settings (admin)

### Payment Endpoints
- `POST /api/payments/tip`: Send tip to performer
- `POST /api/payments/subscription`: Purchase subscription
- `GET /api/payments/history`: View payment history

## Testing Guidelines

### Frontend Testing
- Widget tests for all UI components
- Integration tests for user flows
- Mock API responses for consistent tests
- Test for both success and error scenarios

### Backend Testing
- Unit tests for utility functions
- Integration tests for API endpoints
- Mock database for consistent testing
- Test API for proper error handling

## Security Guidelines

- Sanitize all user inputs
- Use prepared statements for database queries
- Implement rate limiting for API endpoints
- Store passwords with bcrypt hashing
- Use HTTPS for all traffic
- Implement CORS policies
- Set secure and HTTP-only cookies
- Use JWT with proper expiration
- Implement proper roles and permissions
- Audit logging for sensitive operations

## Deployment

### Production
- Frontend: Cloudflare for CDN
- Backend: Ubuntu 24.04 with Docker
- Database: Managed PostgreSQL service
- Monitoring: Prometheus/Grafana
- CI/CD: GitHub Actions

### Staging
- Same structure as production but with separate domains and databases
- Used for testing features before production deployment

## Common Issues & Solutions

### Frontend
- Issue: Black screen in video player
  - Solution: Check RTSP URL format and network connectivity
- Issue: Slow UI performance
  - Solution: Use const widgets and avoid expensive rebuilds

### Backend
- Issue: Database connection errors
  - Solution: Check connection string and network permissions
- Issue: Memory leaks in long-running processes
  - Solution: Implement proper cleanup for event listeners and timers

## Contributing Guidelines

1. Branch naming: `feature/feature-name`, `bugfix/issue-description`, `hotfix/urgent-fix`
2. Commit messages should be descriptive and follow conventional commits format
3. Create pull requests with detailed descriptions
4. Code must pass all tests and lint checks before merging
5. Update documentation for new features
6. Add tests for new functionality

## Roadmap and Feature Implementation

### Phase 1 (Current)
- Single-performer streaming system
- Basic authentication
- Payment processing integration
- Multi-camera support

### Phase 2
- Multi-performer system
- Enhanced security features
- Mobile app development
- Advanced subscription models

### Phase 3
- Platform rebranding
- AI moderation tools
- Analytics dashboard
- Advanced user engagement features