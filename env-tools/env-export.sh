#!/bin/bash
# Environment variables export script
# This script exports all environment variables from .env to the current shell

if [ ! -f .env ]; then
  echo "Error: No .env file found. Run env-setup.sh first to create one."
  exit 1
fi

echo "====================================================="
echo "  Exporting Environment Variables"
echo "====================================================="
echo
echo "This script will export all environment variables from .env"
echo "to your current shell session."
echo
echo "Usage: source ./env-tools/env-export.sh"
echo
echo "NOTE: You must use 'source' or '.' command to run this script"
echo "      for the exports to affect your current shell."
echo "====================================================="

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "❌ ERROR: This script must be sourced, not executed directly."
  echo "Please run: source ${BASH_SOURCE[0]}"
  exit 1
fi

# Export all variables from .env
while IFS= read -r line; do
  # Skip comments and empty lines
  if [[ ! "$line" =~ ^#.*$ ]] && [[ ! -z "$line" ]]; then
    # Extract variable and value
    if [[ "$line" =~ ^([A-Za-z0-9_]+)=(.*)$ ]]; then
      var_name="${BASH_REMATCH[1]}"
      var_value="${BASH_REMATCH[2]}"
      
      # Remove surrounding quotes if present
      var_value="${var_value%\"}"
      var_value="${var_value#\"}"
      var_value="${var_value%\'}"
      var_value="${var_value#\'}"
      
      # Export the variable
      export "$var_name"="$var_value"
      
      # Hide sensitive values in output
      if [[ "$var_name" == *"SECRET"* || "$var_name" == *"PASSWORD"* || "$var_name" == *"KEY"* ]]; then
        echo "Exported $var_name = ********"
      else
        echo "Exported $var_name = $var_value"
      fi
    fi
  fi
done < .env

echo
echo "====================================================="
echo "✅ Environment variables have been exported to your current shell"
echo "You can now run commands that depend on these variables."
echo "====================================================="