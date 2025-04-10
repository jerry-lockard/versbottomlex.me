# Environment Variables Tools

This directory contains tools for managing environment variables in the application.

## Quick Start

The easiest way to set up your environment is to use the setup wizard:

```bash
# Run the setup wizard
./env-tools/env-setup.sh
```

This interactive wizard provides a menu-driven interface for all environment variable management tasks.

## Available Tools

### Main Tools

- **`.env`**: Main environment variables file 
- **`env-setup.sh`**: Menu-driven interface for managing environment variables
- **`env-check.sh`**: Validate environment variables for correctness
- **`env-view.sh`**: Display current environment variables in a readable format
- **`env-export.sh`**: Export variables to your current shell session

### Documentation

- **`ENV-REFERENCE.md`**: Complete reference for all environment variables

## Common Tasks

### Setting Up Environment Variables

```bash
# Use the wizard
./env-tools/env-setup.sh
```

### Validating Your Configuration

After setting up your environment variables, verify they're correct:

```bash
./env-tools/env-check.sh
```

### Viewing Current Settings

```bash
./env-tools/env-view.sh
```

### Exporting to Your Shell

```bash
source ./env-tools/env-export.sh
```

**Note**: You must use `source` (or `.`) to run this script for the exports to affect your current shell.