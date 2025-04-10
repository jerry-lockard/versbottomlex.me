# Changelog

All notable changes to the VersBottomLex.me project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2025-04-09

### Added
- Created comprehensive structured logging system with sensitive data redaction
- Added database connection retry mechanism with exponential backoff
- Implemented CSRF protection with token generation and validation
- Created pagination middleware for API endpoints
- Added request ID tracking for better error tracing
- Implemented socket authentication with JWT verification
- Created custom API error classes for consistent error handling
- Added detailed README.md for backend documentation

### Changed
- Updated database connection management with improved configuration
- Enhanced JWT implementation with separate secrets for access and refresh tokens
- Improved error handling with better context and sanitization
- Updated Socket.IO implementation with enhanced security and event handling
- Improved server startup sequence with proper error handling
- Enhanced validation for password strength requirements

### Security
- Removed hard-coded credentials from configuration files
- Added rate limiting for all API endpoints with stricter limits for auth routes
- Enhanced JWT security with issuer and audience claims
- Improved token verification with version checking
- Added secure session configuration with proper cookie settings
- Enhanced helmet configuration with content security policy
- Added input sanitization and validation for all user inputs
- Improved Socket.IO security with proper authentication and validation

## [0.2.0] - 2025-04-22

### Added
- Implemented enhanced state management using Provider pattern
- Created authentication provider for managing user sessions
- Added theme provider with light/dark mode support
- Created connectivity provider for network status monitoring
- Added real-time connectivity monitoring with automatic retry mechanisms
- Implemented secure credential storage with flutter_secure_storage
- Created development script (`dev.sh`) for starting frontend and backend simultaneously
- Added SSL setup script (`ssl-setup.sh`) for production environments
- Created API testing screen in debug menu for connectivity testing
- Added basic screen implementations:
  - SplashScreen with authentication checking
  - LoginScreen with form validation
  - HomeScreen with tabbed interface and user profile
- Integrated proper CORS configuration on backend for secure communication
- Added automatic token refresh in API service
- Added proper error handling for API requests

### Changed
- Updated main.dart to use Provider for state management
- Improved AppRouter with proper screen navigation
- Enhanced API service with better URL construction and error handling
- Updated backend server.js with proper CORS settings
- Enhanced README with more detailed development setup instructions
- Refactored theme implementation for better dark mode support

### Fixed
- Fixed URL construction in API service for proper endpoint routing
- Fixed CORS issues between frontend and backend communication
- Fixed port mismatch in backend socket.io configuration
- Fixed theme configuration in app_theme.dart

### Security
- Implemented proper CORS policies on backend
- Added secure token storage with flutter_secure_storage
- Configured HTTPS/SSL support for production environments
- Added proper token refresh mechanism to prevent session hijacking

## [0.1.0] - 2025-04-03

### Added
- Initial project setup with Flutter frontend and Node.js backend
- Basic application structure and configuration
- Theme implementation with light and dark modes
- Basic API service for backend communication

### Removed
- Removed default widget test