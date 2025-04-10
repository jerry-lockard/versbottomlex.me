#!/bin/bash

# Setup script for versbottomlex.me webcam chat platform
# Run this script to set up development environment and build the project

# Color codes for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Setting up VersBottomLex.me Development Environment ===${NC}"

# Create necessary directories if they don't exist
echo -e "${YELLOW}Creating project directories...${NC}"
mkdir -p /home/dakota/versbottomlex.me/{frontend,backend,nginx,docker,scripts,docs}
mkdir -p /home/dakota/versbottomlex.me/backend/{src,config,public}
mkdir -p /home/dakota/versbottomlex.me/backend/src/{controllers,models,routes,middlewares,utils,services}

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
  sudo -u postgres psql -c "CREATE DATABASE versbottomlex;"
  sudo -u postgres psql -c "CREATE USER dakota WITH ENCRYPTED PASSWORD 'postgres';"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE versbottomlex TO dakota;"
else
  echo -e "${GREEN}PostgreSQL is already installed.${NC}"
fi

# Set up the backend
echo -e "${YELLOW}Setting up backend...${NC}"
cd /home/dakota/versbottomlex.me/backend
npm install

# Set up the frontend
echo -e "${YELLOW}Setting up frontend...${NC}"
cd /home/dakota/versbottomlex.me/frontend
flutter pub get

# Check for SSL certs directory
mkdir -p /home/dakota/versbottomlex.me/docker/certbot/{conf,www}

echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo -e "${YELLOW}To start the application:${NC}"
echo -e "1. For development:${NC}"
echo -e "   - Backend: cd /home/dakota/versbottomlex.me/backend && npm run dev"
echo -e "   - Frontend: cd /home/dakota/versbottomlex.me/frontend && flutter run -d chrome"
echo -e "2. Using Docker:${NC}"
echo -e "   cd /home/dakota/versbottomlex.me && docker-compose -f docker/docker-compose.yml up"
echo -e "${YELLOW}To access your application:${NC}"
echo -e "   - Backend API: http://localhost:5000"
echo -e "   - Frontend: http://localhost:3000"
echo -e "   - API Documentation: http://localhost:5000/api-docs"
