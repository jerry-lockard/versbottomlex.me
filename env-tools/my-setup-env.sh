#!/bin/bash
# Pre-configured environment variables setup script
# This script will create a .env file with your personal settings

echo "====================================================="
echo "  Setting up your personal environment variables"
echo "====================================================="
echo 
echo "This script will create a .env file with your"
echo "pre-configured settings."
echo
echo "====================================================="

# Create new .env file (or backup existing one)
if [ -f .env ]; then
  echo "Existing .env file found. Creating backup as .env.backup"
  cp .env .env.backup
fi

# Generate .env file with all settings
cat > .env << EOL
# Environment Variables - Created $(date)
# VersBottomLex.me configured settings

# Core Settings
APP_NAME=versbottomlex
PRIMARY_DOMAIN=versbottomlex.me
ADMIN_EMAIL=dakota@versbottomlex.me

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=versbottomlex
DB_USER=postgres
DB_PASSWORD=postgres

# API Configuration
API_HOST=localhost
API_PORT=5000
FRONTEND_URL=https://versbottomlex.me

# Media/Streaming Configuration
MEDIA_HOST=localhost
MEDIA_PORT=8888

# Security
JWT_SECRET=your_super_secret_token_here
JWT_REFRESH_SECRET=your_super_secret_refresh_token_here
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
JWT_ISSUER=versbottomlex.me
JWT_AUDIENCE=versbottomlex-api

# Frontend Configuration
APP_ROOT=/home/dakota/versbottomlex.me/frontend/build/web

# Development environment URLs
DEV_API_URL=http://localhost:3000/api
DEV_SOCKET_URL=http://localhost:3000
DEV_RTMP_URL=rtmp://localhost/live

# Staging environment URLs
STAGING_API_URL=https://staging-api.versbottomlex.me/api
STAGING_SOCKET_URL=https://staging-api.versbottomlex.me
STAGING_RTMP_URL=rtmp://staging-stream.versbottomlex.me/live

# Production environment URLs
PROD_API_URL=https://api.versbottomlex.me/api
PROD_SOCKET_URL=https://api.versbottomlex.me
PROD_RTMP_URL=rtmp://stream.versbottomlex.me/live
EOL

echo "====================================================="
echo "CONFIGURATION COMPLETE!"
echo "====================================================="
echo
echo "Your personal environment variables have been saved to: .env"
echo
echo "Next steps:"
echo "1. Review the .env file to ensure all values are correct"
echo "2. Use 'docker-compose up -d' to start your application"
echo "3. For SSL setup: sudo -E bash scripts/ssl-setup.sh"
echo
echo "Thank you for using the setup script!"
echo "====================================================="

# Make the script executable
chmod +x my-setup-env.sh