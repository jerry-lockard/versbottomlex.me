# VersBottomLex.me Documentation

Comprehensive documentation for the VersBottomLex.me webcam platform.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Development Setup](#development-setup)
3. [Backend API](#backend-api)
4. [Frontend Components](#frontend-components)
5. [Database Schema](#database-schema)
6. [Deployment Guide](#deployment-guide)
7. [Security Considerations](#security-considerations)
8. [Testing Strategy](#testing-strategy)

## Architecture Overview

VersBottomLex.me uses a microservices architecture with:
- **Flutter frontend**: Web, Android, and iOS clients
- **Node.js backend**: RESTful API and business logic
- **PostgreSQL database**: Data persistence
- **WebSocket server**: Real-time communication
- **Media streaming server**: Video streaming management

![Architecture Diagram](docs/architecture_diagram.png)

## Development Setup

### Prerequisites
- Flutter SDK 3.19+
- Node.js 18+
- PostgreSQL 14+
- Docker & Docker Compose (optional)

### Backend Setup
```bash
cd backend
npm install
cp .env.example .env  # Configure environment variables
npm run dev
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run
```

### Docker Setup (Optional)
```bash
docker-compose up -d
```

## Backend API

### Authentication
- `POST /api/auth/register`: Register new user
- `POST /api/auth/login`: Authenticate user
- `POST /api/auth/refresh`: Refresh access token
- `GET /api/auth/me`: Get current user profile

### Streaming
- `GET /api/streams`: List active streams
- `POST /api/streams`: Create new stream
- `GET /api/streams/:id`: Get stream details
- `PUT /api/streams/:id`: Update stream settings

### Payments
- `POST /api/payments/tip`: Send a tip
- `POST /api/payments/purchase`: Purchase private show
- `GET /api/payments/history`: Get payment history

## Frontend Components

### Core Screens
- **Home**: Main landing page with featured streams
- **Stream View**: Watch live stream with chat integration
- **Profile**: User profile management
- **Payment**: Manage payment methods and transactions
- **Admin**: Content moderation and platform management

### State Management
The frontend uses Provider for state management with the following key providers:
- **AuthProvider**: Manages user authentication
- **StreamProvider**: Handles stream data and updates
- **ChatProvider**: Manages real-time chat functionality
- **PaymentProvider**: Handles payment processing

## Database Schema

### Users Table
| Column       | Type         | Description                  |
|--------------|--------------|------------------------------|
| id           | UUID         | Primary key                  |
| username     | VARCHAR(50)  | Unique username              |
| email        | VARCHAR(100) | User email address           |
| password     | VARCHAR(100) | Hashed password              |
| role         | ENUM         | User role (viewer/performer) |
| created_at   | TIMESTAMP    | Account creation time        |
| last_login   | TIMESTAMP    | Last login time              |

### Streams Table
| Column       | Type         | Description                  |
|--------------|--------------|------------------------------|
| id           | UUID         | Primary key                  |
| user_id      | UUID         | Foreign key to users         |
| title        | VARCHAR(100) | Stream title                 |
| description  | TEXT         | Stream description           |
| status       | ENUM         | Stream status                |
| started_at   | TIMESTAMP    | Stream start time            |
| ended_at     | TIMESTAMP    | Stream end time              |

### Payments Table
| Column       | Type         | Description                  |
|--------------|--------------|------------------------------|
| id           | UUID         | Primary key                  |
| user_id      | UUID         | Foreign key to users         |
| stream_id    | UUID         | Foreign key to streams       |
| amount       | DECIMAL      | Payment amount               |
| type         | ENUM         | Payment type (tip/purchase)  |
| status       | ENUM         | Payment status               |
| created_at   | TIMESTAMP    | Payment creation time        |

## Deployment Guide

### Backend Deployment
1. Build the application: `npm run build`
2. Set production environment variables
3. Start with PM2: `pm2 start dist/server.js`

### Frontend Deployment
1. Build the web app: `flutter build web`
2. Deploy to web server (Nginx/Apache)
3. Configure SSL certificate

### Mobile App Release
1. Android: `flutter build apk --release`
2. iOS: `flutter build ios --release`

## Security Considerations

### Authentication
- JWT tokens with short expiration
- Refresh token rotation
- Biometric authentication option

### Data Protection
- HTTPS for all API requests
- Password hashing with bcrypt
- Input validation and sanitization
- SQL injection prevention

### Compliance
- Age verification mechanisms
- GDPR-compliant data handling
- Secure payment processing

## Testing Strategy

### Backend Testing
- Unit tests for business logic
- API integration tests
- Load testing for streaming capacity

### Frontend Testing
- Widget tests for UI components
- Integration tests for user flows
- End-to-end tests for critical paths

### Continuous Integration
- GitHub Actions for automated testing
- Pre-commit hooks for code quality
- Dependency vulnerability scanning