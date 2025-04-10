#!/bin/bash
# ============================================================================
# VersBottomLex.me - Initial Project Setup Script
# ============================================================================
# This script sets up the complete development environment for the 
# VersBottomLex.me webcam streaming platform, including:
#   - Required software dependencies
#   - Project directory structure
#   - Database configuration
#   - Initial frontend and backend setup
#
# Usage: bash scripts/setup.sh
# ============================================================================

set -e  # Exit on any error

# Color codes for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project root directory - derive from script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}    VersBottomLex.me - Initial Project Setup      ${NC}"
echo -e "${GREEN}==================================================${NC}"

# Create necessary directories if they don't exist
echo -e "${BLUE}Creating project directories...${NC}"

# Create project structure based on CLAUDE.md repository structure
mkdir -p "$ROOT_DIR"/{frontend,backend,nginx,docker,scripts,docs}

# Backend structure
mkdir -p "$ROOT_DIR"/backend/{src,config,public,test}
mkdir -p "$ROOT_DIR"/backend/src/{controllers,models,routes,middleware,utils,services,config}

# Frontend structure
mkdir -p "$ROOT_DIR"/frontend/{lib,assets,test}
mkdir -p "$ROOT_DIR"/frontend/lib/{presentation,data,core,utils,config}
mkdir -p "$ROOT_DIR"/frontend/lib/presentation/{screens,widgets,providers,themes}
mkdir -p "$ROOT_DIR"/frontend/lib/data/{models,services,datasources}
mkdir -p "$ROOT_DIR"/frontend/assets/{fonts,images,icons,animations}

echo -e "${GREEN}Project directory structure created successfully!${NC}"

# Check and install system dependencies
echo -e "${YELLOW}Checking system dependencies...${NC}"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check and install Node.js
if ! command_exists node; then
  echo -e "${YELLOW}Installing Node.js...${NC}"
  sudo apt update
  sudo apt install -y nodejs npm
  sudo npm install -g n
  sudo n stable
else
  echo -e "${GREEN}Node.js is already installed.${NC}"
fi

# Check and install Flutter
if ! command_exists flutter; then
  echo -e "${YELLOW}Installing Flutter...${NC}"
  sudo snap install flutter --classic
else
  echo -e "${GREEN}Flutter is already installed.${NC}"
fi

# Check and install Docker
if ! command_exists docker; then
  echo -e "${YELLOW}Installing Docker...${NC}"
  sudo apt update
  sudo apt install -y docker.io docker-compose
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
  echo -e "${YELLOW}Please log out and log back in for Docker permissions to take effect.${NC}"
else
  echo -e "${GREEN}Docker is already installed.${NC}"
fi

# Check and install PostgreSQL
if ! command_exists psql; then
  echo -e "${YELLOW}Installing PostgreSQL...${NC}"
  sudo apt update
  sudo apt install -y postgresql postgresql-contrib
  sudo systemctl start postgresql
  sudo systemctl enable postgresql
  
  # Set up the database
  echo -e "${YELLOW}Setting up PostgreSQL database...${NC}"
  
  # Check if database already exists
  if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "versbottomlex"; then
    echo -e "${GREEN}Database 'versbottomlex' already exists.${NC}"
  else
    echo -e "${BLUE}Creating 'versbottomlex' database...${NC}"
    sudo -u postgres psql -c "CREATE DATABASE versbottomlex;"
    echo -e "${GREEN}Database created successfully.${NC}"
  fi
  
  # Check if user already exists
  if sudo -u postgres psql -c "SELECT 1 FROM pg_roles WHERE rolname='dakota'" | grep -q 1; then
    echo -e "${GREEN}Database user 'dakota' already exists.${NC}"
  else
    echo -e "${BLUE}Creating database user 'dakota'...${NC}"
    sudo -u postgres psql -c "CREATE USER dakota WITH ENCRYPTED PASSWORD 'postgres';"
    echo -e "${GREEN}Database user created successfully.${NC}"
  fi
  
  # Grant privileges
  echo -e "${BLUE}Granting privileges to user 'dakota'...${NC}"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE versbottomlex TO dakota;"
  echo -e "${GREEN}Database permissions granted successfully.${NC}"
  
  # Create .env file for database connection
  if [ ! -f "$ROOT_DIR/backend/.env" ]; then
    echo -e "${BLUE}Creating backend .env file with database credentials...${NC}"
    cat > "$ROOT_DIR/backend/.env" << EOF
# Database Configuration
DATABASE_URL=postgres://dakota:postgres@localhost:5432/versbottomlex
PORT=3000
JWT_SECRET=$(openssl rand -hex 32)
NODE_ENV=development
EOF
    echo -e "${GREEN}Backend .env file created successfully.${NC}"
  else
    echo -e "${YELLOW}Backend .env file already exists. Skipping creation.${NC}"
  fi
else
  echo -e "${GREEN}PostgreSQL is already installed.${NC}"
fi

# Create git hooks directory if needed
if [ ! -d "$ROOT_DIR/.git/hooks" ]; then
  mkdir -p "$ROOT_DIR/.git/hooks"
fi

# Install pre-commit hook
if [ ! -f "$ROOT_DIR/.git/hooks/pre-commit" ]; then
  echo -e "${BLUE}Setting up Git pre-commit hook...${NC}"
  cat > "$ROOT_DIR/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# VersBottomLex.me pre-commit hook

# Colors
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running pre-commit checks...${NC}"

# Check for backend linting
if [ -d "./backend" ] && [ -f "./backend/package.json" ]; then
  if grep -q "\"lint\"" ./backend/package.json; then
    echo "Running backend linting..."
    cd ./backend && npm run lint || { echo -e "${RED}Backend linting failed.${NC}"; exit 1; }
    echo -e "${GREEN}Backend linting passed.${NC}"
  fi
fi

# Check for frontend linting
if [ -d "./frontend" ] && [ -f "./frontend/pubspec.yaml" ]; then
  echo "Running Flutter format check..."
  cd ./frontend && flutter format --set-exit-if-changed lib || { echo -e "${RED}Flutter formatting check failed.${NC}"; exit 1; }
  echo -e "${GREEN}Flutter formatting check passed.${NC}"
  
  echo "Running Flutter analyze..."
  cd ./frontend && flutter analyze || { echo -e "${RED}Flutter analysis failed.${NC}"; exit 1; }
  echo -e "${GREEN}Flutter analysis passed.${NC}"
fi

echo -e "${GREEN}All pre-commit checks passed!${NC}"
exit 0
EOF
  chmod +x "$ROOT_DIR/.git/hooks/pre-commit"
  echo -e "${GREEN}Git pre-commit hook installed successfully.${NC}"
else
  echo -e "${YELLOW}Git pre-commit hook already exists. Skipping installation.${NC}"
fi

# Set up the backend
echo -e "${YELLOW}Setting up backend...${NC}"
cd "$ROOT_DIR/backend" || exit 1

# Check for package.json, create a basic one if it doesn't exist
if [ ! -f "package.json" ]; then
  echo -e "${BLUE}Creating basic package.json for backend...${NC}"
  npm init -y
  
  # Update package.json with required scripts and dependencies
  npm pkg set scripts.start="node src/server.js"
  npm pkg set scripts.dev="nodemon src/server.js"
  npm pkg set scripts.lint="eslint src/**/*.js"
  npm pkg set scripts.test="jest"
  
  # Install core dependencies
  echo -e "${BLUE}Installing backend dependencies...${NC}"
  npm install express dotenv cors helmet jsonwebtoken mongoose pg sequelize bcrypt
  
  # Install dev dependencies
  npm install --save-dev nodemon jest eslint
else
  echo -e "${BLUE}Installing existing backend dependencies...${NC}"
  npm install
fi

# Set up the frontend
echo -e "${YELLOW}Setting up frontend...${NC}"
cd "$ROOT_DIR/frontend" || exit 1

# Check if pubspec.yaml exists, create a basic one if it doesn't exist
if [ ! -f "pubspec.yaml" ]; then
  echo -e "${BLUE}Creating basic pubspec.yaml for frontend...${NC}"
  cat > "pubspec.yaml" << EOF
name: frontend
description: VersBottomLex.me webcam streaming platform frontend
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  provider: ^6.0.5
  http: ^1.1.0
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^8.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.2

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: Montserrat
      fonts:
        - asset: assets/fonts/Montserrat-Regular.ttf
        - asset: assets/fonts/Montserrat-Bold.ttf
          weight: 700
        - asset: assets/fonts/Montserrat-Light.ttf
          weight: 300
        - asset: assets/fonts/Montserrat-Medium.ttf
          weight: 500
        - asset: assets/fonts/Montserrat-SemiBold.ttf
          weight: 600
EOF
fi

echo -e "${BLUE}Installing Flutter dependencies...${NC}"
flutter pub get

# Check for Docker configuration
if [ ! -f "$ROOT_DIR/docker/docker-compose.yml" ]; then
  echo -e "${BLUE}Creating basic Docker configuration...${NC}"
  
  # Create frontend Dockerfile
  mkdir -p "$ROOT_DIR/docker"
  cat > "$ROOT_DIR/docker/frontend.Dockerfile" << 'EOF'
FROM ubuntu:20.04 AS build-env

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    lib32stdc++6 \
    libglu1-mesa \
    default-jdk-headless

# Set up Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor
RUN flutter channel stable
RUN flutter upgrade

# Copy app files
WORKDIR /app
COPY . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web --release

# Production stage
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY docker/nginx-frontend.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

  # Create backend Dockerfile
  cat > "$ROOT_DIR/docker/backend.Dockerfile" << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000
CMD ["node", "src/server.js"]
EOF

  # Create docker-compose.yml
  cat > "$ROOT_DIR/docker/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  frontend:
    build:
      context: ../frontend
      dockerfile: ../docker/frontend.Dockerfile
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: unless-stopped

  backend:
    build:
      context: ../backend
      dockerfile: ../docker/backend.Dockerfile
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgres://postgres:postgres@db:5432/versbottomlex
      - NODE_ENV=production
      - PORT=3000
    restart: unless-stopped

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=versbottomlex
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
EOF

  echo -e "${GREEN}Docker configuration created successfully.${NC}"
fi

# Create SSL certificates directory for future setup
mkdir -p "$ROOT_DIR/docker/certbot/{conf,www}"

# Create or update README.md with basic project information
if [ ! -f "$ROOT_DIR/README.md" ] || [[ $(stat -c%s "$ROOT_DIR/README.md") -lt 100 ]]; then
  echo -e "${BLUE}Creating basic README.md...${NC}"
  cat > "$ROOT_DIR/README.md" << 'EOF'
# VersBottomLex.me

A high-quality webcam streaming platform with secure payment processing, biometric authentication, and cross-platform support.

## Getting Started

### Prerequisites

- Node.js v18+
- Flutter SDK v3.19+
- PostgreSQL v14+
- Docker and Docker Compose (optional, for containerized deployment)

### Development Setup

1. Clone this repository
2. Run the setup script:
   ```bash
   bash scripts/setup.sh
   ```
3. Start the development servers:
   ```bash
   bash scripts/dev.sh
   ```

### Production Deployment

For production deployment, use Docker:

```bash
docker-compose -f docker/docker-compose.yml up -d
```

## Project Structure

- **frontend/**: Flutter-based web/mobile client
- **backend/**: Node.js/Express API server
- **docker/**: Docker configuration files
- **scripts/**: Development and deployment scripts
- **docs/**: Project documentation

## Development Commands

See the CLAUDE.md file for a complete list of development commands.

## API Documentation

API documentation is available at http://localhost:3000/api-docs when the server is running.

## License

This project is proprietary software.

EOF
  echo -e "${GREEN}README.md created successfully.${NC}"
fi

echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}    VersBottomLex.me Setup Complete!              ${NC}"
echo -e "${GREEN}==================================================${NC}"
echo -e "${YELLOW}Quick Start Commands:${NC}"
echo -e ""
echo -e "${GREEN}1. Start Development Environment:${NC}"
echo -e "   ${BLUE}bash scripts/dev.sh${NC}"
echo -e ""
echo -e "${GREEN}2. Using Docker:${NC}"
echo -e "   ${BLUE}docker-compose -f docker/docker-compose.yml up${NC}"
echo -e ""
echo -e "${GREEN}3. Test Database Connection:${NC}"
echo -e "   ${BLUE}bash scripts/test_db_connection.sh${NC}"
echo -e ""
echo -e "${GREEN}4. Set Up SSL Certificates:${NC}"
echo -e "   ${BLUE}export PRIMARY_DOMAIN=\"versbottomlex.me\"${NC}"
echo -e "   ${BLUE}export EMAIL=\"admin@versbottomlex.me\"${NC}"
echo -e "   ${BLUE}sudo -E bash scripts/ssl-setup.sh${NC}"
echo -e ""
echo -e "${YELLOW}Access Your Application:${NC}"
echo -e "   - Backend API: ${BLUE}http://localhost:3000${NC}"
echo -e "   - Frontend: ${BLUE}http://localhost (when running Flutter)${NC}"
echo -e "   - API Documentation: ${BLUE}http://localhost:3000/api-docs${NC}"
echo -e ""
echo -e "${YELLOW}For more information, see:${NC}"
echo -e "   - ${BLUE}README.md${NC} - Project overview"
echo -e "   - ${BLUE}CLAUDE.md${NC} - Development guidelines"
echo -e "   - ${BLUE}docs/${NC} - Detailed documentation"
echo -e "${GREEN}==================================================${NC}"

# Return to the project root directory
cd "$ROOT_DIR" || exit 1
