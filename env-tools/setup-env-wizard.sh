#!/bin/bash
# Environment variables setup wizard
# This is a more comprehensive, menu-driven setup tool for environment variables

# Create env-tools directory if it doesn't exist
mkdir -p env-tools

# Ensure all scripts are executable
chmod +x env-tools/*.sh 2>/dev/null || true

# Print header
clear
echo "====================================================="
echo "       Environment Setup Wizard"
echo "====================================================="
echo
echo "This wizard will help you configure and manage"
echo "environment variables for your application."
echo

# Function to draw menu
draw_menu() {
  echo "====================================================="
  echo "  Main Menu"
  echo "====================================================="
  echo "  1) Create/Update Environment Variables"
  echo "  2) View Current Environment Variables"
  echo "  3) Validate Environment Configuration"
  echo "  4) Load My Predefined Configuration"
  echo "  5) Export Variables to Current Shell"
  echo "  6) Create Environment Files for Different Environments"
  echo "  7) Help & Documentation"
  echo "  0) Exit"
  echo "====================================================="
  echo
  read -p "Enter your choice [0-7]: " menu_choice
}

# Function to check if script exists and run it
run_script() {
  local script_path=$1
  
  if [ -f "$script_path" ]; then
    bash "$script_path"
  else
    echo "Error: Script not found: $script_path"
    echo "It may not have been created yet."
    read -p "Press Enter to continue..."
  fi
}

# Main program loop
while true; do
  draw_menu
  
  case $menu_choice in
    1)
      # Create/Update Environment Variables
      run_script "./setup-env.sh"
      ;;
    2)
      # View Current Environment Variables
      run_script "./env-tools/view-env.sh"
      ;;
    3)
      # Validate Environment Configuration
      run_script "./env-tools/check-env.sh"
      ;;
    4)
      # Load Predefined Configuration
      run_script "./my-setup-env.sh"
      ;;
    5)
      # Export Variables to Current Shell
      echo "To export variables, you need to source the script directly:"
      echo "source ./env-tools/export-env.sh"
      read -p "Press Enter to continue..."
      ;;
    6)
      # Create Environment Files for Different Environments
      echo "====================================================="
      echo "  Create Environment Files"
      echo "====================================================="
      echo
      echo "This will create separate .env files for different environments"
      echo "based on your current configuration."
      echo
      read -p "Proceed? (y/n): " proceed
      
      if [[ "$proceed" == "y" || "$proceed" == "Y" ]]; then
        # Check if .env exists
        if [ ! -f .env ]; then
          echo "Error: No .env file found. Create one first."
          read -p "Press Enter to continue..."
          continue
        fi
        
        # Create development environment
        cp .env .env.development
        echo "Created .env.development"
        
        # Create staging environment
        cp .env .env.staging
        # Update with staging-specific settings
        sed -i 's/NODE_ENV=.*/NODE_ENV=staging/' .env.staging
        echo "Created .env.staging"
        
        # Create production environment
        cp .env .env.production
        # Update with production-specific settings
        sed -i 's/NODE_ENV=.*/NODE_ENV=production/' .env.production
        echo "Created .env.production"
        
        echo "Environment files created successfully!"
      else
        echo "Operation cancelled."
      fi
      read -p "Press Enter to continue..."
      ;;
    7)
      # Help & Documentation
      echo "====================================================="
      echo "  Environment Variables Help"
      echo "====================================================="
      echo
      echo "File Locations:"
      echo "- Main .env file: $(pwd)/.env"
      echo "- Setup script: $(pwd)/setup-env.sh"
      echo "- Pre-configured setup: $(pwd)/my-setup-env.sh"
      echo "- Utility scripts: $(pwd)/env-tools/"
      echo
      echo "Documentation:"
      echo "- For a complete reference of all environment variables,"
      echo "  see: $(pwd)/ENV-REFERENCE.md"
      echo
      echo "Usage Tips:"
      echo "1. Run setup-env.sh to create a new .env file interactively"
      echo "2. Run my-setup-env.sh to use your pre-configured settings"
      echo "3. Use check-env.sh to validate your configuration"
      echo "4. Use view-env.sh to see your current settings"
      echo "5. To export variables to your shell: source env-tools/export-env.sh"
      echo
      read -p "Press Enter to continue..."
      ;;
    0)
      # Exit
      echo "Exiting Environment Setup Wizard. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      read -p "Press Enter to continue..."
      ;;
  esac
  
  # Clear screen for next menu
  clear
done