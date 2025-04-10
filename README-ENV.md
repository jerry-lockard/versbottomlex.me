# Environment Configuration Guide

This project uses environment variables for configuration across different components. Follow this guide to set up your environment correctly.

## Getting Started

1. Copy the example environment file to create your own:
   ```
   cp .env.example .env
   ```

2. Edit the `.env` file and update it with your specific values:
   ```
   nano .env
   ```

## Environment Variables

### Core Configuration
- `APP_NAME`: Your application name (used for container naming)
- `PRIMARY_DOMAIN`: Your primary domain (e.g., example.com)
- `ADMIN_EMAIL`: Administrator email for SSL certificates and notifications

### Database Configuration
- `DB_HOST`: Database host (default: localhost)
- `DB_PORT`: Database port (default: 5432)
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

### API Configuration
- `API_HOST`: API service host
- `API_PORT`: API service port (default: 5000)

### Media/Streaming
- `MEDIA_HOST`: Streaming media service host
- `MEDIA_PORT`: Streaming media service port (default: 8888)

### Security
- `JWT_SECRET`: Secret key for JWT tokens
- `JWT_REFRESH_SECRET`: Secret key for refresh tokens
- `JWT_EXPIRES_IN`: JWT token expiration (default: 15m)
- `JWT_REFRESH_EXPIRES_IN`: Refresh token expiration (default: 7d)
- `JWT_ISSUER`: JWT token issuer (your domain)
- `JWT_AUDIENCE`: JWT audience (typically your API name)

### Frontend Configuration
- `FRONTEND_URL`: Frontend URL for CORS (default: http://localhost:3000)
- `APP_ROOT`: Root directory for web files in Nginx

### Frontend Environment-Specific URLs
- Development:
  - `DEV_API_URL`: Development API URL
  - `DEV_SOCKET_URL`: Development WebSocket URL
  - `DEV_RTMP_URL`: Development streaming URL

- Staging:
  - `STAGING_API_URL`: Staging API URL
  - `STAGING_SOCKET_URL`: Staging WebSocket URL
  - `STAGING_RTMP_URL`: Staging streaming URL

- Production:
  - `PROD_API_URL`: Production API URL
  - `PROD_SOCKET_URL`: Production WebSocket URL
  - `PROD_RTMP_URL`: Production streaming URL

## Usage in Docker

When using Docker Compose, the variables from your `.env` file will be automatically loaded. For example:

```bash
# Load environment variables and start services
source .env && docker-compose up -d
```

## Usage in Scripts

The SSL setup script and database connection script will use these environment variables:

```bash
# For SSL setup
export PRIMARY_DOMAIN="your-domain.com"
export ADMIN_EMAIL="admin@your-domain.com"
sudo -E bash scripts/ssl-setup.sh

# For database testing
export DB_NAME="your_database"
export DB_USER="your_user"
export DB_PASSWORD="your_password"
bash scripts/test_db_connection.sh
```

## Mobile App Configuration

The Flutter app will read environment variables at build time. You can set them when building:

```bash
PRIMARY_DOMAIN=your-domain.com flutter build web
```

Or for Android/iOS:

```bash
PRIMARY_DOMAIN=your-domain.com flutter build apk
```