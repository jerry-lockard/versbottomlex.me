#!/bin/bash
# Development script to start both frontend and backend servers

# Set colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Project root directory
ROOT_DIR="$(pwd)"
FRONTEND_DIR="${ROOT_DIR}/frontend"
BACKEND_DIR="${ROOT_DIR}/backend"

# Print header
echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}    VersBottomLex.me - Development Environment    ${NC}"
echo -e "${GREEN}==================================================${NC}"

# Check if needed tools are installed
check_dependencies() {
  echo -e "${BLUE}Checking dependencies...${NC}"
  
  # Check for npm
  if ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}Error: npm is not installed.${NC}"
    echo -e "Please install Node.js and npm first."
    exit 1
  fi
  
  # Check for Flutter
  if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}Error: Flutter is not installed.${NC}"
    echo -e "Please install Flutter first."
    exit 1
  fi
}

# Install dependencies if needed
install_dependencies() {
  echo -e "${BLUE}Checking and installing dependencies...${NC}"
  
  # Backend dependencies
  echo -e "${BLUE}Installing backend dependencies...${NC}"
  cd "$BACKEND_DIR" || exit
  npm install
  
  # Frontend dependencies
  echo -e "${BLUE}Installing frontend dependencies...${NC}"
  cd "$FRONTEND_DIR" || exit
  flutter pub get
  
  # Return to root
  cd "$ROOT_DIR" || exit
}

# Start backend server
start_backend() {
  echo -e "${BLUE}Starting backend server...${NC}"
  cd "$BACKEND_DIR" || exit
  npm start &
  BACKEND_PID=$!
  echo -e "${GREEN}Backend server started with PID: $BACKEND_PID${NC}"
  echo -e "${GREEN}API available at: http://localhost:3000${NC}"
  
  # Return to root
  cd "$ROOT_DIR" || exit
}

# Start frontend server
start_frontend() {
  echo -e "${BLUE}Starting frontend application...${NC}"
  cd "$FRONTEND_DIR" || exit
  flutter run -d chrome &
  FRONTEND_PID=$!
  echo -e "${GREEN}Frontend server started with PID: $FRONTEND_PID${NC}"
  
  # Return to root
  cd "$ROOT_DIR" || exit
}

# Handle script termination
cleanup() {
  echo -e "${BLUE}Stopping servers...${NC}"
  
  if [ -n "$BACKEND_PID" ]; then
    kill "$BACKEND_PID" 2>/dev/null || true
    echo -e "${GREEN}Backend server stopped${NC}"
  fi
  
  if [ -n "$FRONTEND_PID" ]; then
    kill "$FRONTEND_PID" 2>/dev/null || true
    echo -e "${GREEN}Frontend server stopped${NC}"
  fi
  
  echo -e "${GREEN}Development environment shutdown complete${NC}"
  exit 0
}

# Register the cleanup function for termination signals
trap cleanup SIGINT SIGTERM

# Main execution
check_dependencies
install_dependencies
start_backend
start_frontend

echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}    Development environment is now running!        ${NC}"
echo -e "${GREEN}    - Backend: http://localhost:3000              ${NC}"
echo -e "${GREEN}    - Frontend: Running in Chrome                 ${NC}"
echo -e "${GREEN}    - Press Ctrl+C to stop both servers           ${NC}"
echo -e "${GREEN}==================================================${NC}"

# Wait for user to press Ctrl+C
wait