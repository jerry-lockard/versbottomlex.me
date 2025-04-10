#!/bin/bash
# Environment variables viewer
# This script displays the current environment variables in a formatted way

if [ ! -f .env ]; then
  echo "Error: No .env file found. Run env-setup.sh first to create one."
  exit 1
fi

echo "====================================================="
echo "  Current Environment Variables"
echo "====================================================="
echo

# Function to print a section header
print_section() {
  echo "-----------------------------------------------------"
  echo "  $1"
  echo "-----------------------------------------------------"
}

# Parse .env file and display variables by section
current_section=""

while IFS= read -r line; do
  # Skip empty lines and comments that don't indicate sections
  if [[ -z "$line" || "$line" =~ ^#[^A-Z]+ ]]; then
    continue
  fi
  
  # Check if line is a section header comment
  if [[ "$line" =~ ^#[[:space:]]*(.*)[[:space:]]*$ ]]; then
    section="${BASH_REMATCH[1]}"
    # Only print non-empty sections that look like headers
    if [[ "$section" =~ environment|ENVIRONMENT|Settings|SETTINGS|Configuration|CONFIGURATION|Security|SECURITY ]]; then
      print_section "$section"
      current_section="$section"
    fi
  # Display actual environment variables
  elif [[ "$line" =~ ^([A-Za-z0-9_]+)=(.*)$ ]]; then
    var_name="${BASH_REMATCH[1]}"
    var_value="${BASH_REMATCH[2]}"
    
    # Hide sensitive values
    if [[ "$var_name" == *"SECRET"* || "$var_name" == *"PASSWORD"* || "$var_name" == *"KEY"* ]]; then
      echo "$var_name = ********"
    else
      echo "$var_name = $var_value"
    fi
  fi
done < .env

echo
echo "====================================================="
echo "To modify these variables, use one of these options:"
echo "  - Edit .env directly"
echo "  - Run ./env-tools/env-setup.sh for interactive setup"
echo "====================================================="