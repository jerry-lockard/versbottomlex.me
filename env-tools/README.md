# Environment Variables Tools

This directory contains tools for managing environment variables in the application.

## Quick Start

The easiest way to set up your environment is to use the setup wizard:

```bash
# Run the setup wizard
./setup-env-wizard.sh
```

This interactive wizard provides a menu-driven interface for all environment variable management tasks.

## Available Tools

### Basic Setup Scripts

- **`setup-env.sh`**: Interactive setup that prompts for each variable
- **`my-setup-env.sh`**: Pre-configured setup with default values
- **`setup-env-wizard.sh`**: Menu-driven interface for all env management tasks

### Management Tools

- **`view-env.sh`**: Display current environment variables in a readable format
- **`check-env.sh`**: Validate environment variables for correctness
- **`export-env.sh`**: Export variables to your current shell session

### Documentation

- **`ENV-REFERENCE.md`**: Complete reference for all environment variables

## Common Tasks

### Setting Up Environment Variables

```bash
# Option 1: Use the wizard (recommended)
./setup-env-wizard.sh

# Option 2: Interactive setup
./setup-env.sh

# Option 3: Use pre-configured settings
./my-setup-env.sh
```

### Validating Your Configuration

After setting up your environment variables, verify they're correct:

```bash
./check-env.sh
```

### Viewing Current Settings

```bash
./view-env.sh
```

### Exporting to Your Shell

```bash
source ./export-env.sh
```

**Note**: You must use `source` (or `.`) to run this script for the exports to affect your current shell.