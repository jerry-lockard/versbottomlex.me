# VersBottomLex.me Backend

Node.js backend service for the VersBottomLex.me webcam platform.

## Features

- RESTful API for frontend integration
- Real-time chat using WebSockets
- Secure authentication with JWT
- Payment processing system
- Video streaming management
- Admin panel for content moderation

## Architecture

The backend follows a modular architecture with:
- Express.js for API routes
- PostgreSQL database for persistent storage
- Middleware for authentication and request validation
- Service layer for business logic
- Repository pattern for data access

## Getting Started

### Prerequisites
- Node.js v18+
- npm v9+
- PostgreSQL v14+

### Installation
1. Clone the repository
2. Run `npm install` to install dependencies
3. Configure environment variables (see `.env.example`)
4. Set up the PostgreSQL database

### Running the Server
```bash
# Development mode
npm run dev

# Production mode
npm start
```

### Testing
```bash
# Run all tests
npm test

# Run specific test file
npm test -- --testPathPattern=auth.test.js
```

## API Documentation

Once the server is running, API documentation is available at:
- Swagger UI: `http://localhost:3000/api-docs`

## Folder Structure
```
src/
├── config/         # Configuration files
├── controllers/    # Route controllers
├── middleware/     # Custom middleware
├── models/         # Database models
├── routes/         # API routes
├── services/       # Business logic
├── utils/          # Utility functions
└── server.js       # Application entry point
```

## Deployment
- Set NODE_ENV=production
- Configure database connection string
- Set up process manager (PM2 recommended)
- Configure reverse proxy with Nginx