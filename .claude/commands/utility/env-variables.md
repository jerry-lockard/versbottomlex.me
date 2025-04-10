# Environment Variables Extractor

Analyze the entire VersBottomLex.me codebase to identify, document, and organize all environment variables used throughout the application.

## Extraction Requirements
- **Scope**: All source code files
- **Languages**: JavaScript, TypeScript, Dart, Shell scripts
- **Output Format**: Structured Markdown document
- **Level of Detail**: {{basic|detailed|comprehensive}}

## Analysis Components

### 1. Environment Variable Inventory
- [ ] Scan all source files for environment variable references
- [ ] Identify variable declaration patterns
- [ ] Extract environment variable names
- [ ] Categorize by subsystem (frontend, backend, infrastructure)
- [ ] Detect default values
- [ ] Identify required vs. optional variables
- [ ] Note variable interdependencies
- [ ] Detect inconsistencies in usage

### 2. Variable Documentation
For each identified environment variable, document:
- [ ] Variable name (exact casing)
- [ ] Description and purpose
- [ ] Expected data type
- [ ] Allowable values/constraints
- [ ] Default value (if any)
- [ ] Required status
- [ ] Used in which environments (dev/test/prod)
- [ ] Security sensitivity level
- [ ] Source file locations where used
- [ ] Examples of correct values

### 3. Categorization
Organize variables by functional categories:
- [ ] Authentication & Security
- [ ] Database Configuration
- [ ] API Configuration
- [ ] Third-party Integrations
- [ ] Feature Flags
- [ ] Logging & Monitoring
- [ ] Performance Settings
- [ ] Development Tools
- [ ] Testing Configuration
- [ ] Infrastructure Settings

### 4. Template Generation
- [ ] Create `.env.example` template
- [ ] Generate documentation comments for each variable
- [ ] Specify required vs. optional clearly
- [ ] Include example values
- [ ] Group logically by subsystem

### 5. Usage Analysis
- [ ] Identify most commonly used variables
- [ ] Detect potentially unused variables
- [ ] Flag inconsistent variable naming patterns
- [ ] Identify security-sensitive variables
- [ ] Note variables used in critical paths

### 6. Security Assessment
- [ ] Identify sensitive environment variables
- [ ] Flag hardcoded credentials or tokens
- [ ] Recommend secure storage alternatives for sensitive values
- [ ] Check for encryption needs
- [ ] Identify variables requiring rotation policies

## Deliverables

### 1. Environment Variable Reference Document
- [ ] Complete table of all variables
- [ ] Detailed descriptions and constraints
- [ ] Categorized organization
- [ ] Usage examples
- [ ] Code references

### 2. Configuration Templates
- [ ] `.env.example` for local development
- [ ] Environment-specific templates (dev, test, staging, prod)
- [ ] Docker environment configuration
- [ ] CI/CD pipeline configuration examples

### 3. Security Recommendations
- [ ] Best practices for environment variable management
- [ ] Security improvement recommendations
- [ ] Variable isolation strategies

### 4. Implementation Guidelines
- [ ] Standardized variable naming conventions
- [ ] Documentation requirements for new variables
- [ ] Testing practices for environment configurations
- [ ] Management strategy recommendations

Create a comprehensive environment variable reference guide that serves as a single source of truth for the entire development team, ensuring consistent configuration and proper security practices.