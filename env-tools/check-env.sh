#!/bin/bash
# Environment variables validation script
# This script checks if all required variables are set and have valid values

if [ ! -f .env ]; then
  echo "Error: No .env file found. Run setup-env.sh first to create one."
  exit 1
fi

echo "====================================================="
echo "  Environment Variables Validation"
echo "====================================================="
echo

# Source the .env file to load variables
source .env

# Function to check if a variable is set
check_required() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "❌ ERROR: Required variable $var_name is not set"
    VALIDATION_FAILED=true
  else
    echo "✅ $var_name is set"
  fi
}

# Function to check URL format
check_url() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "⚠️ WARNING: $var_name is not set"
  elif [[ ! "$var_value" =~ ^https?:// && ! "$var_value" =~ ^rtmp:// ]]; then
    echo "❌ ERROR: $var_name does not look like a valid URL (missing protocol)"
    VALIDATION_FAILED=true
  else
    echo "✅ $var_name is a valid URL format"
  fi
}

# Function to check if domain is valid
check_domain() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "❌ ERROR: $var_name is not set"
    VALIDATION_FAILED=true
  elif [[ "$var_value" == "example.com" ]]; then
    echo "⚠️ WARNING: $var_name is still set to the default example.com"
  elif [[ ! "$var_value" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
    echo "⚠️ WARNING: $var_name may not be a valid domain format"
  else
    echo "✅ $var_name is valid"
  fi
}

# Function to check if email is valid
check_email() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "❌ ERROR: $var_name is not set"
    VALIDATION_FAILED=true
  elif [[ "$var_value" == *"example.com"* ]]; then
    echo "⚠️ WARNING: $var_name is still using an example.com email"
  elif [[ ! "$var_value" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "❌ ERROR: $var_name is not a valid email format"
    VALIDATION_FAILED=true
  else
    echo "✅ $var_name is valid"
  fi
}

# Function to check if port is valid
check_port() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "⚠️ WARNING: $var_name is not set"
  elif ! [[ "$var_value" =~ ^[0-9]+$ ]] || [ "$var_value" -lt 1 ] || [ "$var_value" -gt 65535 ]; then
    echo "❌ ERROR: $var_name is not a valid port (must be 1-65535)"
    VALIDATION_FAILED=true
  else
    echo "✅ $var_name is valid"
  fi
}

# Function to check if security keys are strong enough
check_security_key() {
  local var_name=$1
  local var_value=${!var_name}
  
  if [ -z "$var_value" ]; then
    echo "❌ ERROR: Required security variable $var_name is not set"
    VALIDATION_FAILED=true
  elif [[ "$var_value" == *"your_"* || "$var_value" == *"example"* || ${#var_value} -lt 16 ]]; then
    echo "❌ ERROR: $var_name appears to be a default or weak value"
    VALIDATION_FAILED=true
  else
    echo "✅ $var_name is set and appears to be strong"
  fi
}

# Initialize validation status
VALIDATION_FAILED=false

echo "Checking core settings..."
check_required "APP_NAME"
check_domain "PRIMARY_DOMAIN"
check_email "ADMIN_EMAIL"
echo

echo "Checking database configuration..."
check_required "DB_NAME"
check_required "DB_USER"
check_required "DB_PASSWORD"
check_required "DB_HOST"
check_port "DB_PORT"
echo

echo "Checking API configuration..."
check_required "API_HOST"
check_port "API_PORT"
check_url "FRONTEND_URL"
echo

echo "Checking security settings..."
check_security_key "JWT_SECRET"
check_security_key "JWT_REFRESH_SECRET"
check_required "JWT_EXPIRES_IN"
check_required "JWT_REFRESH_EXPIRES_IN"
check_domain "JWT_ISSUER"
check_required "JWT_AUDIENCE"
echo

echo "Checking URL configurations..."
check_url "DEV_API_URL"
check_url "DEV_SOCKET_URL"
check_url "DEV_RTMP_URL"
check_url "STAGING_API_URL"
check_url "STAGING_SOCKET_URL"
check_url "STAGING_RTMP_URL"
check_url "PROD_API_URL"
check_url "PROD_SOCKET_URL"
check_url "PROD_RTMP_URL"
echo

# Print final result
echo "====================================================="
if [ "$VALIDATION_FAILED" = true ]; then
  echo "❌ VALIDATION FAILED: There are issues with your environment variables"
  echo "Please fix the errors above before proceeding."
  exit 1
else
  echo "✅ VALIDATION PASSED: All required environment variables are set correctly"
  echo "Your environment is properly configured."
fi
echo "====================================================="