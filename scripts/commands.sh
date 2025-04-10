#!/bin/bash
# ============================================================================
# VersBottomLex.me - Claude Code Command Setup Script
# ============================================================================
# This script creates a structured directory of command files for use with
# Claude Code. Each command file contains a template that guides Claude in
# generating specific code, documentation, or performing analysis.
#
# Usage: bash scripts/commands.sh
# ============================================================================

set -e  # Exit on any error

echo "Setting up Claude Code command structure..."

# Create base directory if it doesn't exist
if [ ! -d ".claude" ]; then
  mkdir -p .claude
  echo "Created .claude directory"
fi

# Create commands directory if it doesn't exist
if [ ! -d ".claude/commands" ]; then
  mkdir -p .claude/commands
  echo "Created .claude/commands directory"
fi

# Define all command categories
CATEGORIES=(
  "frontend"   # Flutter UI and client-side functionality
  "backend"    # Node.js API and server-side functionality
  "server"     # Infrastructure and deployment
  "project"    # Project management and planning
  "docs"       # Documentation generation
  "business"   # Marketing, monetization, and business logic
  "utility"    # Developer tools and utilities
)

# Create directory for each category
for category in "${CATEGORIES[@]}"; do
  if [ ! -d ".claude/commands/$category" ]; then
    mkdir -p ".claude/commands/$category"
    echo "Created .claude/commands/$category directory"
  fi
done

echo "Directory structure created successfully!"

# ============================================================================
# Creating command files for each category
# ============================================================================
echo "Generating command templates..."

# ---------------------------------------------
# DOCS DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating documentation commands..."

# 1. README Generator
cat > .claude/commands/docs/readme-generate.md << 'EOF'
Generate a comprehensive README.md for VersBottomLex.me that includes:

1. Project overview and purpose
2. Installation instructions for both frontend and backend
3. Usage guide for developers and end-users
4. Architecture overview
5. API documentation summary
6. Deployment process
7. Contributing guidelines
8. License information

Use the current project structure and code to inform the content.
EOF

# 2. README Update
cat > .claude/commands/docs/readme-update.md << 'EOF'
Update the existing README.md for VersBottomLex.me with the following new information:

New content: {{description_of_changes}}

Please:
1. Preserve the existing structure and formatting
2. Seamlessly integrate the new information
3. Update any outdated information
4. Ensure all sections remain cohesive
5. Add a "Last Updated" timestamp at the bottom
EOF

# 3. Changelog Generator
cat > .claude/commands/docs/changelog.md << 'EOF'
Create or update CHANGELOG.md for VersBottomLex.me by analyzing recent code changes.

Please:
1. Follow Keep a Changelog format (https://keepachangelog.com/)
2. Categorize changes as Added, Changed, Deprecated, Removed, Fixed, or Security
3. Include relevant ticket/issue numbers if available
4. Maintain previous entries if updating an existing changelog
5. Set today's date for the newest version
EOF

# 4. Development Journal
cat > .claude/commands/docs/devlog.md << 'EOF'
Create a detailed entry for the development journal documenting today's progress on VersBottomLex.me:

Focus areas: {{areas_worked_on}}
Achievements: {{what_was_completed}}
Challenges: {{issues_encountered}}
Next steps: {{upcoming_tasks}}

Format this as a dated Markdown entry that can be added to DEVLOG.md.
EOF

# 5. Git Commit Message
cat > .claude/commands/docs/commit-message.md << 'EOF'
Generate a well-structured git commit message for the following changes to VersBottomLex.me:

Changes made: {{description_of_changes}}

The commit message should:
1. Have a concise subject line (50 chars or less)
2. Include a detailed body explaining the why, not just the what
3. Reference any relevant issue numbers
4. Follow conventional commits format (feat/fix/docs/etc.)
5. Mention affected components (frontend/backend/etc.)
EOF

echo "Documentation commands created successfully!"

# ---------------------------------------------
# FRONTEND DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating frontend commands..."

# 1. Flutter UI Component Generator
cat > .claude/commands/frontend/component.md << 'EOF'
Create a Flutter UI component for VersBottomLex.me with the following details:

Component name: {{component_name}}
Purpose: {{purpose}}
Required features:
- {{features}}

Please include:
1. The main widget class with proper StatefulWidget/StatelessWidget structure
2. Any necessary state management
3. Proper theming consistent with a webcam platform
4. Responsive design considerations
5. Comments explaining the component's purpose and usage
EOF

# 2. Flutter Authentication
cat > .claude/commands/frontend/auth.md << 'EOF'
Create a biometric authentication implementation for the VersBottomLex Flutter app using flutter_local_auth. Include:

1. The necessary imports and dependencies for pubspec.yaml
2. A complete authentication service class
3. UI components for the authentication flow
4. Error handling and fallback authentication methods
5. How to integrate this with the rest of the app
EOF

# 3. Flutter Stream Player
cat > .claude/commands/frontend/stream-player.md << 'EOF'
Create a Flutter implementation for displaying RTSP video streams from Wyze cameras. Include:

1. Required packages and dependencies for pubspec.yaml
2. A video player widget that can handle RTSP streams
3. Controls for the video player (play/pause, fullscreen, etc.)
4. Error handling for connection issues
5. How to optimize performance for live streaming
EOF

# 4. Payment Integration
cat > .claude/commands/frontend/payment.md << 'EOF'
Create code for integrating payment processing in the Flutter frontend for VersBottomLex.me. Include:

1. UI components for displaying payment options (CCBill, Paxum, Crypto)
2. Implementation for processing payments
3. Security considerations
4. How to handle successful/failed transactions
5. How this connects to the backend services
EOF

# 5. Flutter Build and Deploy
cat > .claude/commands/frontend/deploy.md << 'EOF'
Review my Flutter web build configuration and provide a complete deployment script that:

1. Optimizes the Flutter web build for production
2. Transfers the build files to the correct Nginx directory
3. Updates any necessary permissions
4. Verifies the deployment was successful
5. Includes error handling and rollback capabilities
EOF

# 6. Frontend Code Review
cat > .claude/commands/frontend/code-review.md << 'EOF'
Review the following Flutter code from my VersBottomLex.me project:

EOF

# 7. State Management Setup
cat > .claude/commands/frontend/state-management.md << 'EOF'
Create a complete state management implementation for the VersBottomLex.me Flutter app using:

State management solution: {{provider/bloc/riverpod/redux}}

Include:
1. Required package dependencies
2. Base structure for state classes
3. Implementation for a concrete example (user authentication)
4. How to consume the state in UI components
5. Testing strategy for the state management
EOF

# 8. Theme Generator
cat > .claude/commands/frontend/theme.md << 'EOF'
Create a comprehensive theming system for the VersBottomLex.me Flutter app that includes:

1. A complete ThemeData configuration
2. Dark and light mode support
3. Brand color palette definition
4. Typography scale
5. Custom theme extensions for app-specific styling

The theme should align with the aesthetic of a premium webcam platform.
EOF

# 9. Navigation System
cat > .claude/commands/frontend/navigation.md << 'EOF'
Design a routing and navigation system for the VersBottomLex.me Flutter app that includes:

1. Route definitions for all major screens
2. Navigation state management
3. Deep linking support
4. Transition animations
5. Authentication-based route guards
EOF

# 10. Localization Setup
cat > .claude/commands/frontend/localization.md << 'EOF'
Create a complete internationalization setup for the VersBottomLex.me Flutter app that:

1. Configures the necessary packages and dependencies
2. Sets up the structure for translation files
3. Implements the localization delegate
4. Shows example usage in UI components
5. Includes a language switching mechanism
EOF

# 11. Firebase Integration
cat > .claude/commands/frontend/firebase.md << 'EOF'
Create a complete Firebase integration for the VersBottomLex.me Flutter app that includes:

1. Required dependencies and initialization code
2. Authentication integration
3. Firestore/Realtime Database setup for user data
4. Cloud Messaging for notifications
5. Analytics configuration
EOF

echo "Frontend commands created successfully!"

# ---------------------------------------------
# BACKEND DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating backend commands..."

# 1. Node.js API Endpoint
cat > .claude/commands/backend/api-endpoint.md << 'EOF'
Create a Node.js API endpoint for the following feature in the VersBottomLex.me backend:

Endpoint: {{endpoint_path}}
Purpose: {{purpose}}
Request method: {{GET/POST/PUT/DELETE}}
Required authentication: {{Yes/No}}
Request parameters:
- {{param_name}}: {{description}}

Please include:
1. Complete implementation with proper error handling
2. Input validation
3. Authentication checks if required
4. Documentation comments
5. Example request/response
EOF

# 2. WebRTC Implementation
cat > .claude/commands/backend/webrtc.md << 'EOF'
Create a Node.js implementation for handling WebRTC connections for live streaming in the VersBottomLex.me backend. Include:

1. Required dependencies and setup
2. Signal server implementation
3. Managing peer connections
4. Handling connection issues and reconnections
5. Security considerations
EOF

# 3. Database Schema
cat > .claude/commands/backend/database-schema.md << 'EOF'
Design a PostgreSQL database schema for the VersBottomLex.me platform that includes:

1. User accounts (performers and viewers)
2. Payment transactions
3. Stream information and history
4. User interactions (tips, messages, etc.)
5. Analytics data

For each table, include column definitions, data types, constraints, and relationships.
EOF

# 4. PM2 Configuration
cat > .claude/commands/backend/pm2-config.md << 'EOF'
Create a PM2 configuration file for running the VersBottomLex.me Node.js backend. Include:

1. Process name and instance count
2. Environment variables
3. Log file configuration
4. Restart policy
5. Monitoring settings
EOF

# 5. Backend Code Review
cat > .claude/commands/backend/code-review.md << 'EOF'
Review the following Node.js code from my VersBottomLex.me backend:

EOF

# 6. WebSocket Implementation
cat > .claude/commands/backend/websocket.md << 'EOF'
Create a WebSocket implementation for the VersBottomLex.me backend that handles:

1. Real-time chat between viewers and performers
2. Live notification system
3. Tip alerts and animations
4. Connection management and error handling
5. Authentication and security measures
EOF

# 7. Caching Strategy
cat > .claude/commands/backend/caching.md << 'EOF'
Design and implement a caching strategy for the VersBottomLex.me backend that:

1. Identifies appropriate data to cache
2. Implements Redis or a similar caching solution
3. Handles cache invalidation
4. Optimizes API response times
5. Includes monitoring and metrics
EOF

# 8. Payment Webhook Handlers
cat > .claude/commands/backend/payment-webhooks.md << 'EOF'
Create webhook handlers for the payment systems used by VersBottomLex.me:

Payment providers: CCBill, Paxum, Cryptocurrency

Include:
1. Endpoint implementation for each provider
2. Request validation and security checks
3. Transaction processing logic
4. Error handling and retry mechanisms
5. Logging and monitoring
EOF

# 9. Authentication System
cat > .claude/commands/backend/auth-system.md << 'EOF'
Implement a complete authentication system for the VersBottomLex.me backend that includes:

1. User registration and login endpoints
2. JWT token generation and validation
3. Role-based access control
4. Password reset functionality
5. Session management
EOF

# 10. Analytics Tracking
cat > .claude/commands/backend/analytics.md << 'EOF'
Design and implement an analytics tracking system for VersBottomLex.me that:

1. Tracks key user interactions
2. Records performance metrics
3. Implements event logging
4. Provides data aggregation
5. Includes dashboard visualization options
EOF

echo "Backend commands created successfully!"

# ---------------------------------------------
# SERVER DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating server commands..."

# 1. Nginx Configuration
cat > .claude/commands/server/nginx-config.md << 'EOF'
Create or update the Nginx configuration for versbottomlex.me with the following requirements:

1. Serve Flutter web app from /home/dakota/versbottomlex.me/frontend/build
2. Proxy API requests to the Node.js backend running on port 3000
3. Implement appropriate caching strategies
4. Configure security headers
5. Optimize for performance

Include the complete configuration file and commands to test and apply it.
EOF

# 2. SSL Certificate Setup
cat > .claude/commands/server/ssl-setup.md << 'EOF'
Create a comprehensive script for setting up and renewing SSL certificates for versbottomlex.me using Certbot. Include:

1. Installation steps for Certbot
2. Commands to obtain certificates for both versbottomlex.me and www.versbottomlex.me
3. Nginx configuration updates for HTTPS
4. Auto-renewal setup
5. Testing commands to verify the configuration
EOF

# 3. Server Security 
cat > .claude/commands/server/security.md << 'EOF'
Analyze the security of my Ubuntu 24.04 server for versbottomlex.me and provide:

1. A complete checklist of security measures to implement
2. Commands to configure UFW firewall rules
3. Steps to secure SSH access
4. User permission recommendations
5. Regular security maintenance tasks
EOF

# 4. Server Monitoring
cat > .claude/commands/server/monitoring.md << 'EOF'
Create a setup script for monitoring the VersBottomLex.me server that:

1. Installs appropriate monitoring tools
2. Configures alerts for critical events
3. Sets up resource usage monitoring
4. Monitors application health
5. Creates a dashboard for easy visualization
EOF

# 5. Backup Strategy
cat > .claude/commands/server/backup.md << 'EOF'
Design a comprehensive backup strategy for VersBottomLex.me that includes:

1. Database backups
2. Code repositories
3. User-generated content
4. Server configuration
5. Automated scheduling and retention policies

Include all necessary scripts and commands.
EOF

# 6. Docker Setup
cat > .claude/commands/server/docker.md << 'EOF'
Create a complete Docker setup for VersBottomLex.me that includes:

1. Dockerfile for the Node.js backend
2. Docker Compose configuration for the entire stack
3. Production-ready optimizations
4. Volume management for persistent data
5. Deployment instructions
EOF

# 7. CI/CD Pipeline
cat > .claude/commands/server/cicd.md << 'EOF'
Design a CI/CD pipeline for VersBottomLex.me using GitHub Actions that:

1. Runs tests on pull requests
2. Builds the Flutter web application
3. Deploys to the production server
4. Includes staging environment support
5. Handles database migrations
EOF

# 8. Load Testing
cat > .claude/commands/server/load-testing.md << 'EOF'
Create a comprehensive load testing plan for VersBottomLex.me that:

1. Identifies critical paths to test
2. Implements testing scripts using a tool like k6 or JMeter
3. Defines success criteria and metrics
4. Includes baseline and stress test scenarios
5. Provides reporting and visualization
EOF

# 9. Server Migration
cat > .claude/commands/server/migration.md << 'EOF'
Create a detailed plan for migrating VersBottomLex.me to a new server that includes:

1. Pre-migration checklist
2. Data backup procedures
3. Step-by-step migration process
4. Verification steps
5. Rollback procedure in case of failure
EOF

# 10. Database Backup Automation
cat > .claude/commands/server/db-backup.md << 'EOF'
Create a comprehensive database backup automation script for VersBottomLex.me that:

1. Performs regular PostgreSQL backups
2. Includes both full and incremental backup strategies
3. Implements backup rotation and cleanup
4. Adds verification of backup integrity
5. Includes restoration testing procedure
EOF

echo "Server commands created successfully!"

# ---------------------------------------------
# PROJECT DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating project management commands..."

# 1. Project Status
cat > .claude/commands/project/status.md << 'EOF'
Analyze my VersBottomLex.me project and provide:

1. Current implementation status compared to requirements
2. Outstanding critical tasks
3. Potential technical challenges and solutions
4. Optimization recommendations
5. Next steps prioritized by importance
EOF

# 2. Feature Implementation Plan
cat > .claude/commands/project/feature-plan.md << 'EOF'
Create a detailed implementation plan for the following feature in VersBottomLex.me:

Feature: {{feature_name}}
Description: {{description}}

Include:
1. Required frontend components
2. Backend API endpoints
3. Database changes
4. Integration points with existing code
5. Testing strategy
EOF

# 3. Code Documentation
cat > .claude/commands/project/documentation.md << 'EOF'
Generate comprehensive documentation for the following component of VersBottomLex.me:

Component: {{component_name}}
Type: {{Frontend/Backend}}

Create documentation that includes:
1. Purpose and functionality
2. Architecture and design decisions
3. API reference (if applicable)
4. Usage examples
5. Common issues and solutions
EOF

# 4. Scaling Strategy
cat > .claude/commands/project/scaling.md << 'EOF'
Analyze the current architecture of VersBottomLex.me and provide a comprehensive scaling strategy for transitioning to a multi-performer platform. Include:

1. Architecture changes required
2. Database scaling considerations
3. Content delivery optimization
4. Load balancing implementation
5. Cost projections and performance benchmarks
EOF

# 5. Testing Strategy
cat > .claude/commands/project/testing.md << 'EOF'
Create a complete testing strategy for VersBottomLex.me that includes:

1. Unit testing approach for both frontend and backend
2. Integration testing plan
3. End-to-end testing scenarios
4. Performance testing methodology
5. Security testing checklist

Include example tests for critical components.
EOF

echo "Project management commands created successfully!"

# ---------------------------------------------
# BUSINESS DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating business commands..."

# 1. SEO Optimization
cat > .claude/commands/business/seo.md << 'EOF'
Analyze the VersBottomLex.me website and provide a comprehensive SEO optimization plan that includes:

1. Meta tag recommendations
2. Content optimization suggestions
3. Structured data implementation
4. Page speed improvements
5. Mobile optimization strategies
EOF

# 2. Marketing Copy
cat > .claude/commands/business/marketing.md << 'EOF'
Generate marketing copy for the following aspect of VersBottomLex.me:

Feature/page: {{feature_name}}
Target audience: {{audience_description}}
Key messaging: {{main_points}}

Include:
1. Headline options
2. Feature description
3. Benefits-focused bullet points
4. Call to action variations
5. Tone that aligns with the brand voice
EOF

# 3. User Onboarding Flow
cat > .claude/commands/business/onboarding.md << 'EOF'
Design a complete user onboarding flow for new users of VersBottomLex.me that:

1. Introduces key features
2. Guides users through account setup
3. Implements progressive disclosure
4. Includes email communications
5. Measures completion metrics
EOF

# 4. Privacy Policy Generator
cat > .claude/commands/business/privacy-policy.md << 'EOF'
Generate a comprehensive privacy policy for VersBottomLex.me that covers:

1. Data collection practices
2. User rights and controls
3. Cookie usage
4. Third-party integrations
5. Compliance with relevant regulations (GDPR, CCPA, etc.)
EOF

# 5. Monetization Strategy
cat > .claude/commands/business/monetization.md << 'EOF'
Analyze the current VersBottomLex.me platform and provide a detailed monetization strategy that includes:

1. Revenue model optimization
2. Pricing strategy for different tiers
3. Loyalty and retention programs
4. Cross-selling and upselling opportunities
5. Payment processing optimization
EOF

echo "Business commands created successfully!"

# ---------------------------------------------
# UTILITY DIRECTORY COMMANDS
# ---------------------------------------------
echo "Creating utility commands (with enhanced Claude Code format)..."

# 1. Code Generator
cat > .claude/commands/utility/code-generator.md << 'EOF'
# Code Generator

Generate boilerplate code for a new feature in VersBottomLex.me:

## Input Parameters
- Feature name: {{feature_name}}
- Type: {{frontend/backend/both}}
- Description: {{feature_description}}
- Dependencies: {{related_packages_or_libraries}}

## Instructions
Generate all necessary files, classes, and methods for implementing this feature.
The code should follow the project's existing patterns and best practices.

## Output Format
Provide the files as code blocks with appropriate file paths and explanations
for how they interact with the existing codebase.

```
file: /path/to/new/file.ext
```

[Your code here]

## Implementation Notes
- Ensure all necessary imports are included
- Follow the existing architecture patterns
- Include appropriate error handling
- Add comments explaining complex logic
EOF

# 2. Dependency Analyzer
cat > .claude/commands/utility/dependencies.md << 'EOF'
# Dependency Analysis

## Task Description
Analyze the dependencies in the VersBottomLex.me project and provide a comprehensive assessment.

## Input Parameters
- Project section to analyze: {{frontend/backend/both}}
- Focus areas: {{security/performance/size/all}}

## Analysis Requirements
Please provide the following in your analysis:

1. **Outdated Packages**
   - List packages that need updating
   - Current vs. latest versions
   - Breaking changes to be aware of

2. **Security Assessment**
   - Known vulnerabilities in current dependencies
   - CVSS scores for identified vulnerabilities
   - Remediation recommendations

3. **Package Alternatives**
   - Recommendations for better alternatives
   - Comparison of features and tradeoffs
   - Migration complexity assessment

4. **Performance Impact**
   - Bundle size analysis
   - Startup time impact
   - Runtime performance considerations

5. **Optimization Recommendations**
   - Unused dependencies to remove
   - Consolidation opportunities
   - Specific upgrade paths with code examples

## Output Format
Provide your analysis in a structured format with clear headers and actionable recommendations.
Include specific commands for implementing your recommendations where applicable.
EOF

# 3. Performance Profiler
cat > .claude/commands/utility/performance.md << 'EOF'
# Performance Analysis

## Component to Analyze
- Component name: {{component_name}}
- Type: {{frontend/backend}}
- Main functionality: {{brief_description}}

## Analysis Scope
Perform a comprehensive performance analysis of the specified component, focusing on execution efficiency, memory usage, and user experience impact.

## Required Analysis

1. **Bottleneck Identification**
   - Time complexity analysis of key algorithms
   - Execution profiling to identify slow operations
   - Rendering performance (if frontend)
   - Database query efficiency (if backend)

2. **Memory Usage Analysis**
   - Memory leak detection
   - Heap allocation patterns
   - Garbage collection impact
   - Cache utilization effectiveness

3. **Optimization Recommendations**
   - Algorithm improvements
   - Caching strategies
   - Code refactoring suggestions
   - Asset optimization (if frontend)

4. **Metrics Projection**
   - Current performance baseline
   - Expected improvements with optimizations
   - Quantified metrics (response times, memory usage, etc.)
   - User experience impact

5. **Implementation Plan**
   - Prioritized list of optimizations
   - Code examples for key improvements
   - Testing strategy to validate improvements
   - Progressive implementation approach

## Output Format
Provide a structured report with code examples, metrics, and clear recommendations.
Use tables and comparative analysis where appropriate.
EOF

# 4. Code Quality Check
cat > .claude/commands/utility/code-quality.md << 'EOF'
# Code Quality Analysis

## Target for Analysis
- Path: {{file_or_directory_path}}
- Language/Framework: {{language_or_framework}}
- Purpose: {{brief_description}}

## Analysis Requirements
Perform a comprehensive code quality assessment with actionable recommendations.

## Analysis Categories

1. **Linting & Style Issues**
   - Code style inconsistencies
   - Formatting problems
   - Violation of project conventions
   - Unused imports or variables

2. **Code Smells**
   - Duplicate code
   - Long methods/functions
   - Complex conditionals
   - Excessive nesting
   - Poor naming conventions

3. **Potential Bugs**
   - Null/undefined reference risks
   - Race conditions
   - Resource leaks
   - Error handling gaps
   - Type inconsistencies

4. **Performance Concerns**
   - Inefficient algorithms
   - Unnecessary computations
   - Suboptimal data structures
   - Rendering inefficiencies (if frontend)
   - Query performance (if backend)

5. **Maintainability Improvements**
   - Documentation needs
   - Test coverage gaps
   - Architecture violations
   - Refactoring opportunities
   - Modularization suggestions

## Output Format
Provide findings in a structured report with:
- Severity ratings for each issue
- Code examples showing problems
- Suggested fixes with code snippets
- Prioritized recommendations

For critical issues, provide complete replacement code blocks that can be directly implemented.
EOF

# 5. API Documentation Generator
cat > .claude/commands/utility/api-docs.md << 'EOF'
# API Documentation Generator

## Documentation Scope
Generate comprehensive API documentation for the VersBottomLex.me backend endpoints.

## Input Parameters
- API category: {{api_category}}
- Format desired: {{swagger/markdown/both}}
- Include examples: {{yes/no}}

## Documentation Requirements

1. **OpenAPI/Swagger Specification**
   - Complete specification in YAML format
   - API version information
   - Server configurations
   - Global parameters and security schemes

2. **Endpoint Descriptions**
   - Grouped by resource/functionality
   - Purpose and usage context
   - Rate limiting information
   - Deprecation notices where applicable

3. **Request/Response Models**
   - Complete schema definitions
   - Required vs. optional fields
   - Data types and constraints
   - Relationships between models

4. **Authentication & Authorization**
   - Auth mechanisms for each endpoint
   - Required permissions/scopes
   - Token usage instructions
   - Error responses for auth failures

5. **Example Requests/Responses**
   - Curl command examples
   - Request body samples in JSON
   - Response examples for success cases
   - Response examples for common error cases

## Output Format
Provide the documentation in the requested format(s):
- If Swagger: Complete YAML file ready for import to Swagger UI
- If Markdown: Well-structured documentation with proper headers and code blocks
- If both: Both formats with consistent information

Ensure all examples are valid and reflect the actual API behavior.
EOF
