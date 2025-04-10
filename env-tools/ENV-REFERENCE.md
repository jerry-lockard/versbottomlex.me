# Environment Variables Reference

This document provides a comprehensive reference for all environment variables used throughout the application. Use it as a guide when configuring your development, testing, and production environments.

## Table of Contents

1. [Core Application Settings](#core-application-settings)
2. [Database Configuration](#database-configuration)
3. [Authentication & Security](#authentication--security)
4. [API & Server Configuration](#api--server-configuration)
5. [Streaming Configuration](#streaming-configuration)
6. [Frontend Configuration](#frontend-configuration)
7. [Nginx Configuration](#nginx-configuration)
8. [Docker & Infrastructure](#docker--infrastructure)
9. [Environment-Specific Settings](#environment-specific-settings)

## Core Application Settings

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `APP_NAME` | Application name used for container naming and display | String | `myapp` | No | Low |
| `NODE_ENV` | Application environment mode | String<br>(`development`, `production`, `test`) | `development` | No | Low |
| `PRIMARY_DOMAIN` | Main domain for the application | String | `example.com` | Yes | Medium |
| `ADMIN_EMAIL` | Administrator email for notifications and certificates | Email | - | Yes | Medium |

## Database Configuration

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `DB_NAME` | PostgreSQL database name | String | `app_database` | Yes | Medium |
| `DB_USER` | PostgreSQL username | String | `postgres` | Yes | Medium |
| `DB_PASSWORD` | PostgreSQL password | String | `postgres` | Yes | High |
| `DB_HOST` | Database host address | String | `localhost` | No | Medium |
| `DB_PORT` | Database port | Number | `5432` | No | Low |
| `DATABASE_URL` | Full PostgreSQL connection string | URL | - | No | High |
| `DB_POOL_MAX` | Maximum database connections | Number | `5` | No | Low |
| `DB_POOL_MIN` | Minimum database connections | Number | `0` | No | Low |
| `DB_POOL_ACQUIRE` | Connection acquire timeout (ms) | Number | `30000` | No | Low |
| `DB_POOL_IDLE` | Connection idle timeout (ms) | Number | `10000` | No | Low |

**Example:**
```
DB_NAME=streaming_app
DB_USER=app_user
DB_PASSWORD=secure_password
DB_HOST=postgres
DB_PORT=5432
```

## Authentication & Security

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `JWT_SECRET` | Secret key for JWT tokens | String | - | Yes | Critical |
| `JWT_REFRESH_SECRET` | Secret key for refresh tokens | String | - | Yes | Critical |
| `JWT_EXPIRES_IN` | Access token expiration time | Duration | `15m` | No | Medium |
| `JWT_REFRESH_EXPIRES_IN` | Refresh token expiration time | Duration | `7d` | No | Medium |
| `JWT_ISSUER` | Token issuer (typically your domain) | String | `example.com` | No | Medium |
| `JWT_AUDIENCE` | Token audience (API identifier) | String | `app-api` | No | Medium |
| `SESSION_SECRET` | Secret for session middleware | String | Random 32-byte hex | No | Critical |

**Example:**
```
JWT_SECRET=your-long-random-secret-key-here-at-least-32-chars
JWT_REFRESH_SECRET=different-long-random-secret-key-here
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
```

## API & Server Configuration

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `PORT` | Application server port | Number | `5000` | No | Low |
| `API_HOST` | API service host | String | `localhost` | No | Medium |
| `API_PORT` | API service port | Number | `5000` | No | Low |
| `API_URL` | Complete API base URL | URL | `http://localhost:5000` | No | Medium |
| `FRONTEND_URL` | Frontend URL for CORS | URL | `http://localhost:3000` | No | Medium |
| `LOG_LEVEL` | Logging verbosity | String<br>(`ERROR`, `WARN`, `INFO`, `DEBUG`) | `INFO` in prod<br>`DEBUG` in dev | No | Low |
| `RATE_LIMIT_WINDOW_MS` | Rate limiting window (ms) | Number | `900000` | No | Low |
| `RATE_LIMIT_MAX` | Maximum requests per window | Number | `100` | No | Low |

**Example:**
```
PORT=5000
API_HOST=api
FRONTEND_URL=https://app.example.com
LOG_LEVEL=INFO
```

## Streaming Configuration

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `RTMP_SERVER_URL` | RTMP server URL | URL | `rtmp://localhost/live` | No | Medium |
| `HLS_SERVER_URL` | HLS server URL for playback | URL | `http://localhost:8080/hls` | No | Medium |
| `MEDIA_HOST` | Streaming media service host | String | `localhost` | No | Medium |
| `MEDIA_PORT` | Streaming media service port | Number | `8888` | No | Low |

**Example:**
```
RTMP_SERVER_URL=rtmp://streaming.example.com/live
HLS_SERVER_URL=https://streaming.example.com/hls
MEDIA_HOST=media
MEDIA_PORT=8888
```

## Frontend Configuration

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `APP_ROOT` | Root directory for web files in Nginx | Path | `/usr/share/nginx/html` | No | Low |

## Nginx Configuration

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `PRIMARY_DOMAIN` | Primary domain for SSL certificates | String | `example.com` | Yes | Medium |
| `API_HOST` | API host for proxy | String | `localhost` | No | Medium |
| `API_PORT` | API port for proxy | Number | `5000` | No | Low |
| `MEDIA_HOST` | Media server host for proxy | String | `localhost` | No | Medium |
| `MEDIA_PORT` | Media server port for proxy | Number | `8888` | No | Low |

## Docker & Infrastructure

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `APP_NAME` | Container name prefix | String | `app` | No | Low |
| `PRIMARY_DOMAIN` | Domain for SSL certificates | String | `example.com` | Yes | Medium |
| `ADMIN_EMAIL` | Email for SSL certificates | Email | - | Yes | Medium |

## Environment-Specific Settings

These variables set URLs for different environments in the frontend Flutter application.

### Development Environment

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `DEV_API_URL` | Development API URL | URL | `http://localhost:3000/api` | No | Low |
| `DEV_SOCKET_URL` | Development WebSocket URL | URL | `http://localhost:3000` | No | Low |
| `DEV_RTMP_URL` | Development RTMP URL | URL | `rtmp://localhost/live` | No | Low |

### Staging Environment

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `STAGING_API_URL` | Staging API URL | URL | `https://staging-api.$primaryDomain/api` | No | Medium |
| `STAGING_SOCKET_URL` | Staging WebSocket URL | URL | `https://staging-api.$primaryDomain` | No | Medium |
| `STAGING_RTMP_URL` | Staging RTMP URL | URL | `rtmp://staging-stream.$primaryDomain/live` | No | Medium |

### Production Environment

| Variable | Description | Type | Default | Required | Sensitivity |
|----------|-------------|------|---------|----------|-------------|
| `PROD_API_URL` | Production API URL | URL | `https://api.$primaryDomain/api` | No | Medium |
| `PROD_SOCKET_URL` | Production WebSocket URL | URL | `https://api.$primaryDomain` | No | Medium |
| `PROD_RTMP_URL` | Production RTMP URL | URL | `rtmp://stream.$primaryDomain/live` | No | Medium |

## Security Recommendations

1. **Critical Variables**: Always keep `JWT_SECRET`, `JWT_REFRESH_SECRET`, `SESSION_SECRET`, and `DB_PASSWORD` secure and never commit them to version control.

2. **Production Security**: In production environments, use a secrets management solution rather than .env files for critical secrets.

3. **Rotation Policy**: Implement a regular rotation schedule for all security-sensitive variables.

4. **Environment Isolation**: Use different values for all security-sensitive variables across development, staging, and production.

5. **Variable Validation**: The application validates critical variables at startup (like database credentials and JWT secrets) and will exit if they're not provided.

## Usage Examples

### Local Development

```bash
# Basic setup
PORT=5000
NODE_ENV=development
DB_NAME=app_dev
DB_USER=postgres
DB_PASSWORD=postgres
JWT_SECRET=dev-jwt-secret
JWT_REFRESH_SECRET=dev-refresh-secret
```

### Docker Compose

```bash
# Load environment variables and start services
source .env && docker-compose up -d
```

### SSL Setup

```bash
# For SSL certificate setup
export PRIMARY_DOMAIN="your-domain.com"
export ADMIN_EMAIL="admin@your-domain.com"
sudo -E bash scripts/ssl-setup.sh
```

### Flutter Configuration

```bash
# Set environment variables for Flutter app build
PRIMARY_DOMAIN=your-domain.com flutter build web
```

## Implementation Notes

- All environment variables can be set in a `.env` file at the project root
- Variables are loaded using the `dotenv` package in the backend
- Frontend environment variables are injected at build time
- Docker Compose automatically loads variables from `.env` file
- Variable defaults are defined in respective configuration files