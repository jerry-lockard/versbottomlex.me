#!/bin/bash
# ============================================================================
# Database Connection Test Script
# ============================================================================
# This script tests the connection to the PostgreSQL database for the
# streaming platform.
#
# Usage: bash scripts/test_db_connection.sh
# ============================================================================

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Script directory - to determine project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}    Database Connection Test    ${NC}"
echo -e "${BLUE}==================================================${NC}"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if psql is installed
if ! command_exists psql; then
  echo -e "${RED}Error: PostgreSQL client (psql) is not installed.${NC}"
  echo -e "Please install the PostgreSQL client package first:"
  echo -e "${YELLOW}sudo apt update && sudo apt install postgresql-client${NC}"
  exit 1
fi

# Check for backend .env file first
DB_ENV_FILE="$ROOT_DIR/backend/.env"
if [ -f "$DB_ENV_FILE" ]; then
  echo -e "${GREEN}Found backend .env file. Extracting database connection information...${NC}"
  
  # Try to extract DATABASE_URL from .env file
  if grep -q "DATABASE_URL=" "$DB_ENV_FILE"; then
    DB_URL=$(grep "DATABASE_URL=" "$DB_ENV_FILE" | cut -d '=' -f2)
    echo -e "${GREEN}Found DATABASE_URL in .env file.${NC}"
    
    # Parse the DATABASE_URL to extract components
    if [[ "$DB_URL" =~ postgres://([^:]+):([^@]+)@([^:]+):([0-9]+)/(.+) ]]; then
      DB_USER="${BASH_REMATCH[1]}"
      DB_PASSWORD="${BASH_REMATCH[2]}"
      DB_HOST="${BASH_REMATCH[3]}"
      DB_PORT="${BASH_REMATCH[4]}"
      DB_NAME="${BASH_REMATCH[5]}"
      
      echo -e "${BLUE}Extracted database connection parameters:${NC}"
      echo -e "  Host: ${DB_HOST}"
      echo -e "  Port: ${DB_PORT}"
      echo -e "  Database: ${DB_NAME}"
      echo -e "  User: ${DB_USER}"
    else
      echo -e "${YELLOW}Could not parse DATABASE_URL format. Will use environment variables or defaults.${NC}"
    fi
  fi
fi

# If we couldn't extract from .env file, check environment variables
if [ -z "${DB_USER:-}" ]; then
  # Set defaults for optional parameters
  DB_HOST=${DB_HOST:-${HOST:-localhost}}
  DB_PORT=${DB_PORT:-${PORT:-5432}}
  
  # Check required environment variables
  DB_USER=${DB_USER:-$USER}
  DB_PASSWORD=${DB_PASSWORD:-}
  DB_NAME=${DB_NAME:-app_database}
  
  # Prompt for password if not set
  if [ -z "$DB_PASSWORD" ]; then
    echo -e "${YELLOW}Database password not found in environment variables.${NC}"
    echo -e "${BLUE}Enter the PostgreSQL password for user '${DB_USER}':${NC}"
    read -s DB_PASSWORD
    echo ""
  fi
fi

echo -e "${BLUE}Attempting to connect to database with the following parameters:${NC}"
echo -e "  Host: ${DB_HOST}"
echo -e "  Port: ${DB_PORT}"
echo -e "  Database: ${DB_NAME}"
echo -e "  User: ${DB_USER}"

# Build connection string for PGPASSWORD
export PGPASSWORD="$DB_PASSWORD"

# Test the connection
echo -e "${BLUE}Testing database connection...${NC}"
CONNECTION_RESULT=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 'Connection successful!' AS status;" -t 2>&1)

# Check for connection success
if [[ "$CONNECTION_RESULT" == *"Connection successful"* ]]; then
  echo -e "${GREEN}==================================================${NC}"
  echo -e "${GREEN}    Database connection successful!               ${NC}"
  echo -e "${GREEN}==================================================${NC}"
  
  # Get some basic database information
  echo -e "${BLUE}Database version:${NC}"
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();" -t
  
  echo -e "${BLUE}Database size:${NC}"
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT pg_size_pretty(pg_database_size('$DB_NAME'));" -t
  
  # List tables if there are any
  TABLE_COUNT=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" -t | xargs)
  
  if [ "$TABLE_COUNT" -gt 0 ]; then
    echo -e "${BLUE}Database tables (${TABLE_COUNT}):${NC}"
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name;" -t
  else
    echo -e "${YELLOW}No tables found in database.${NC}"
  fi
  
  # Save connection details to logs
  mkdir -p "$ROOT_DIR/logs"
  LOG_FILE="$ROOT_DIR/logs/db_connection_test_$(date +"%Y%m%d_%H%M%S").log"
  
  {
    echo "Database Connection Test Summary"
    echo "================================"
    echo "Date: $(date)"
    echo ""
    echo "Connection Parameters:"
    echo "- Host: $DB_HOST"
    echo "- Port: $DB_PORT"
    echo "- Database: $DB_NAME"
    echo "- User: $DB_USER"
    echo ""
    echo "Connection Result: Success"
    echo "Database Version: $(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();" -t | xargs)"
    echo "Database Size: $(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT pg_size_pretty(pg_database_size('$DB_NAME'));" -t | xargs)"
    echo ""
    echo "Table Count: $TABLE_COUNT"
    if [ "$TABLE_COUNT" -gt 0 ]; then
      echo "Tables:"
      psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name;" -t
    else
      echo "No tables found."
    fi
  } > "$LOG_FILE"
  
  echo -e "${GREEN}Connection details saved to: $LOG_FILE${NC}"
  exit 0
else
  echo -e "${RED}==================================================${NC}"
  echo -e "${RED}    Database connection failed!                    ${NC}"
  echo -e "${RED}==================================================${NC}"
  echo -e "${RED}Error: $CONNECTION_RESULT${NC}"
  
  echo -e "${YELLOW}Possible solutions:${NC}"
  echo -e "1. Check that PostgreSQL is running:"
  echo -e "   ${BLUE}sudo systemctl status postgresql${NC}"
  echo -e "2. Verify the database exists:"
  echo -e "   ${BLUE}sudo -u postgres psql -c '\l'${NC}"
  echo -e "3. Verify the user exists and has proper permissions:"
  echo -e "   ${BLUE}sudo -u postgres psql -c '\du'${NC}"
  echo -e "4. Check that the connection parameters are correct"
  echo -e "5. Ensure PostgreSQL is configured to allow connections"
  
  # Save error details to logs
  mkdir -p "$ROOT_DIR/logs"
  ERROR_LOG_FILE="$ROOT_DIR/logs/db_connection_error_$(date +"%Y%m%d_%H%M%S").log"
  
  {
    echo "Database Connection Test Error"
    echo "=============================="
    echo "Date: $(date)"
    echo ""
    echo "Connection Parameters:"
    echo "- Host: $DB_HOST"
    echo "- Port: $DB_PORT"
    echo "- Database: $DB_NAME"
    echo "- User: $DB_USER"
    echo ""
    echo "Error Details:"
    echo "$CONNECTION_RESULT"
  } > "$ERROR_LOG_FILE"
  
  echo -e "${YELLOW}Error details saved to: $ERROR_LOG_FILE${NC}"
  exit 1
fi