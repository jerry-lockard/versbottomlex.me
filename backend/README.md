# VersBottomLex.me Backend

A secure, scalable Node.js backend for the VersBottomLex.me livestreaming platform.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Authentication](#authentication)
- [Database](#database)
- [WebSockets](#websockets)
- [Security](#security)
- [Error Handling](#error-handling)
- [Logging](#logging)
- [Testing](#testing)
- [Deployment](#deployment)

## Overview

The VersBottomLex.me backend provides a secure API and real-time communications infrastructure for a webcam streaming platform. It handles user authentication, stream management, payments, and real-time chat functionality.

## Features

- **User Management**: Registration, authentication, profile management
- **Stream Management**: Create, update, delete streams
- **Real-time Communication**: Live chat during streams using Socket.IO
- **Payment Processing**: Secure payment handling
- **Security**: Rate limiting, CSRF protection, JWT authentication
- **Documentation**: Swagger API documentation

## Technology Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL with Sequelize ORM
- **Authentication**: JWT with refresh tokens
- **Real-time Communication**: Socket.IO
- **API Documentation**: Swagger/OpenAPI
- **Validation**: Express Validator
- **Security**: Helmet, CORS, Rate Limiting, CSRF Protection
- **Logging**: Custom structured logger

## Getting Started

### Prerequisites

- Node.js (v14+)
- PostgreSQL (v12+)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/versbottomlex-backend.git
   cd versbottomlex-backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file based on `.env.example`:
   ```bash
   cp .env.example .env
   ```

4. Modify the `.env` file with your configuration values.

5. Start the development server:
   ```bash
   npm run dev
   ```

### Configuration

The application uses environment variables for configuration. See `.env.example` for a complete list of variables.

Key configuration categories:

- **Server**: Port, environment, URLs
- **Database**: Connection details, pool configuration
- **JWT**: Secret keys, token expiration
- **Security**: Session secret, CSRF settings
- **Logging**: Log level and format

## Project Structure

```
src/
├── config/         # Configuration files
├── controllers/    # Request handlers
├── middleware/     # Express middleware
├── models/         # Database models and associations
├── routes/         # API route definitions
├── services/       # Business logic
├── utils/          # Utility functions
└── server.js       # Express application setup
```

## API Documentation

API documentation is available via Swagger UI at `/api-docs` when the server is running.

### API Endpoints

- **Auth**: `/api/auth/*` - Authentication endpoints
  - `POST /api/auth/register` - Register a new user
  - `POST /api/auth/login` - Authenticate user
  - `POST /api/auth/refresh` - Refresh access token
  - `GET /api/auth/me` - Get current user info
  - `POST /api/auth/change-password` - Change password
  - `POST /api/auth/logout` - Logout (invalidate tokens)

- **Users**: `/api/users/*` - User management endpoints
  - `GET /api/users/:id` - Get user profile
  - `PUT /api/users/:id` - Update user profile
  - `DELETE /api/users/:id` - Delete user account

- **Streams**: `/api/streams/*` - Stream management endpoints
  - `GET /api/streams` - List all active streams
  - `POST /api/streams` - Create a new stream
  - `GET /api/streams/:id` - Get stream details
  - `PUT /api/streams/:id` - Update stream
  - `DELETE /api/streams/:id` - End stream

- **Payments**: `/api/payments/*` - Payment handling endpoints
  - `POST /api/payments/tip` - Send a tip
  - `GET /api/payments/history` - Get payment history

## Authentication

Authentication is implemented using JWT (JSON Web Tokens) with a two-token strategy:

1. **Access Token**: Short-lived token (15 minutes) used for API authentication
2. **Refresh Token**: Longer-lived token (7 days) used to obtain new access tokens

### Token Security Features:

- Separate secrets for access and refresh tokens
- Signed with issuer and audience claims
- Token versioning to invalidate tokens on password change or logout
- Secure storage recommendations (httpOnly cookies in frontend)

### Authentication Flow:

1. **Login**: Submit credentials, receive access and refresh tokens
2. **API Access**: Include access token in Authorization header
3. **Token Refresh**: Use refresh token to get a new access token when expired
4. **Logout**: Invalidate tokens by incrementing token version

## Database

The application uses PostgreSQL with Sequelize ORM for data persistence.

### Models:

- **User**: User accounts and profiles
- **Stream**: Streaming session details
- **Message**: Chat messages during streams
- **Payment**: Payment/tip records

### Connection Management:

- Connection pooling for performance
- Automatic retry with exponential backoff
- Environment-based configuration

## WebSockets

Real-time communication is implemented using Socket.IO.

### Socket.IO Features:

- Authentication via JWT
- Room-based communication for streams
- Event handlers for chat messages, tips, user joins/leaves
- Security validations on messages and events

### Socket Events:

- **joinRoom**: Join a stream's chat room
- **leaveRoom**: Leave a stream's chat room
- **chatMessage**: Send a chat message
- **tipReceived**: Notify when a tip is received
- **streamUpdate**: Update stream status
- **userJoined**: Notify when a user joins
- **userLeft**: Notify when a user leaves

## Security

### Security Features:

1. **Rate Limiting**:
   - Global rate limits for all endpoints
   - Stricter limits for authentication endpoints
   - Even stricter limits for sensitive operations (password change)

2. **CSRF Protection**:
   - Token-based CSRF protection
   - Secure token generation and validation
   - Exemption for GET requests

3. **Secure Headers (Helmet)**:
   - Content Security Policy
   - XSS Protection
   - Content Type Options
   - Referrer Policy

4. **Session Security**:
   - Secure, httpOnly cookies
   - Session expiration
   - Session store recommendations for production

5. **Request Validation**:
   - Input validation with Express Validator
   - Parameter sanitization
   - File upload restrictions

## Error Handling

The application implements a centralized error handling mechanism.

### Error Features:

- Custom ApiError class for consistent error responses
- HTTP status code mapping
- Detailed error messages in development, sanitized in production
- Request IDs for error tracking
- Structured error logging

### Error Types:

- Bad Request (400)
- Unauthorized (401)
- Forbidden (403)
- Not Found (404)
- Conflict (409)
- Validation Error (422)
- Too Many Requests (429)
- Internal Server Error (500)

## Logging

The application uses a custom structured logger.

### Logging Features:

- Log levels (ERROR, WARN, INFO, DEBUG)
- Automatic sensitive data redaction
- JSON-formatted logs for machine processing
- Environment-based log level configuration

### Log Example:
```json
{
  "timestamp": "2023-04-09T15:30:45.123Z",
  "level": "INFO",
  "message": "User registered successfully",
  "data": { "userId": "123e4567-e89b-12d3-a456-426614174000" }
}
```

## Testing

Tests are written using Jest and Supertest.

### Running Tests:

```bash
npm test
```

### Test Types:

- Unit tests for utilities and services
- Integration tests for API endpoints
- Model tests for database operations

## Deployment

### Production Recommendations:

1. **Database**:
   - Use a managed database service
   - Set up regular backups
   - Configure connection pooling

2. **Security**:
   - Set up HTTPS with proper certificates
   - Use a reverse proxy (e.g., Nginx)
   - Implement a Web Application Firewall

3. **Scaling**:
   - Use a process manager (PM2)
   - Consider containerization (Docker)
   - Set up load balancing for horizontal scaling

4. **Session Storage**:
   - Use Redis for session store in production
   - Configure proper session expiration

5. **Monitoring**:
   - Implement health checks
   - Set up application monitoring
   - Configure error alerting

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributors

- Dakota Alexander <dakota@versbottomlex.me>