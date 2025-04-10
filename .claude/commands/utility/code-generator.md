# Comprehensive Feature Code Generator

Generate complete, production-ready code implementation for a new VersBottomLex.me feature that follows clean architecture, best practices, and platform conventions.

## Feature Requirements

### Core Specification
- **Feature Name**: {{feature_name}}
- **Implementation Type**: {{frontend|backend|full-stack}}
- **Priority**: {{high|medium|low}}
- **Business Value**: {{business_value}}
- **Target Audience**: {{user_types}}
- **Target Release**: {{release_version}}

### User Stories
- **Primary Story**: As a {{user_type}}, I want to {{action}} so that {{benefit}}.
- **Additional Stories**: {{additional_user_stories}}
- **Acceptance Criteria**: {{acceptance_criteria}}

### Technical Context
- **Dependencies**: {{external_dependencies}}
- **Related Features**: {{related_features}}
- **Technical Constraints**: {{constraints}}
- **Required Services**: {{required_services}}
- **API Endpoints**: {{api_endpoints}}
- **Data Requirements**: {{data_requirements}}
- **Estimated Complexity**: {{simple|moderate|complex|very_complex}}

## Architecture Components

### Frontend Implementation (Flutter)

#### 1. Data Layer
- [ ] **Models**
  - [ ] Data models with proper typing
  - [ ] JSON serialization/deserialization
  - [ ] Model validation
  - [ ] Unit tests for models
  - [ ] Documentation with example usage

- [ ] **Repositories**
  - [ ] Repository interfaces
  - [ ] Repository implementations
  - [ ] Error handling strategy
  - [ ] Caching mechanism
  - [ ] Offline support strategy
  - [ ] Unit tests for repositories
  - [ ] Mock implementations for testing

- [ ] **Data Sources**
  - [ ] Remote data source
  - [ ] Local data source
  - [ ] API client implementation
  - [ ] Database interactions
  - [ ] Error mapping
  - [ ] Unit tests for data sources

#### 2. Domain Layer
- [ ] **Entities**
  - [ ] Core business entities
  - [ ] Value objects
  - [ ] Entity validation rules
  - [ ] Entity relationships
  - [ ] Business logic encapsulation
  - [ ] Unit tests for entities

- [ ] **Use Cases**
  - [ ] Use case interfaces
  - [ ] Use case implementations
  - [ ] Business rule enforcement
  - [ ] Error handling
  - [ ] Logging strategy
  - [ ] Unit tests for use cases
  - [ ] Documentation with example usage

#### 3. Presentation Layer
- [ ] **State Management**
  - [ ] State management setup (Provider/Bloc/Riverpod)
  - [ ] State definitions
  - [ ] Events/actions definitions
  - [ ] State transitions
  - [ ] Error states
  - [ ] Loading states
  - [ ] Unit tests for state management
  - [ ] Integration with repositories/use cases

- [ ] **UI Components**
  - [ ] Screens
    - [ ] `/frontend/lib/presentation/screens/{{feature_directory}}/`
    - [ ] Screen layout implementation
    - [ ] Responsive design
    - [ ] State connection
    - [ ] Navigation handling
    - [ ] Error handling
    - [ ] Loading indicators
    - [ ] Widget tests

  - [ ] Widgets
    - [ ] `/frontend/lib/presentation/components/{{feature_directory}}/`
    - [ ] Reusable widget implementation
    - [ ] Theme integration
    - [ ] Accessibility support
    - [ ] Input validation
    - [ ] Animation implementation
    - [ ] Widget tests
    - [ ] Example documentation

- [ ] **Navigation**
  - [ ] Route definitions in `/frontend/lib/core/app_router.dart`
  - [ ] Deep link handling
  - [ ] Route guards
  - [ ] Navigation state preservation
  - [ ] Back button handling
  - [ ] Tests for navigation

- [ ] **Theming**
  - [ ] Theme extensions in `/frontend/lib/presentation/themes/app_theme.dart`
  - [ ] Dark/light mode support
  - [ ] Custom component styling
  - [ ] Consistent spacing
  - [ ] Accessibility considerations

- [ ] **Assets**
  - [ ] `/frontend/assets/{{asset_type}}/`
  - [ ] Asset optimization
  - [ ] Asset registration in pubspec.yaml
  - [ ] Asset usage documentation

#### 4. Cross-Cutting Concerns
- [ ] **Internationalization**
  - [ ] Strings extraction
  - [ ] Translation implementation
  - [ ] RTL support if needed
  - [ ] Pluralization handling
  - [ ] Date/number formatting

- [ ] **Analytics**
  - [ ] Event tracking
  - [ ] User property tracking
  - [ ] Crash reporting
  - [ ] Performance monitoring

- [ ] **Permissions**
  - [ ] Permission requests
  - [ ] Permission state handling
  - [ ] Graceful degradation

- [ ] **Error Handling**
  - [ ] User-friendly error messages
  - [ ] Error logging
  - [ ] Crash reporting
  - [ ] Recovery mechanisms

### Backend Implementation (Node.js)

#### 1. API Layer
- [ ] **Routes**
  - [ ] `/backend/src/routes/{{feature_name}}.routes.js`
  - [ ] Route definitions
  - [ ] Route parameter validation
  - [ ] Authentication requirements
  - [ ] Rate limiting
  - [ ] Response format standardization
  - [ ] Tests for routes

- [ ] **Controllers**
  - [ ] `/backend/src/controllers/{{feature_name}}.controller.js`
  - [ ] Request handling
  - [ ] Input validation
  - [ ] Business logic orchestration
  - [ ] Response formatting
  - [ ] Error handling
  - [ ] Logging
  - [ ] Unit tests for controllers

- [ ] **Middleware**
  - [ ] `/backend/src/middleware/{{feature_specific}}.middleware.js`
  - [ ] Authentication/authorization checks
  - [ ] Request validation
  - [ ] Rate limiting
  - [ ] Request logging
  - [ ] Error handling
  - [ ] Tests for middleware

- [ ] **Validators**
  - [ ] Input validation schemas
  - [ ] Custom validation rules
  - [ ] Validation error messages
  - [ ] Sanitization rules
  - [ ] Tests for validators

#### 2. Business Logic Layer
- [ ] **Services**
  - [ ] `/backend/src/services/{{feature_name}}.service.js`
  - [ ] Business logic implementation
  - [ ] Service interfaces
  - [ ] Error handling
  - [ ] Transaction management
  - [ ] External service integration
  - [ ] Caching strategy
  - [ ] Unit tests for services

- [ ] **Events**
  - [ ] Event definitions
  - [ ] Event dispatching
  - [ ] Event handling
  - [ ] Tests for events

#### 3. Data Access Layer
- [ ] **Models**
  - [ ] `/backend/src/models/{{feature_name}}.model.js`
  - [ ] Schema definitions
  - [ ] Validation rules
  - [ ] Indexing strategy
  - [ ] Relationships
  - [ ] Hooks/middleware
  - [ ] Query methods
  - [ ] Tests for models

- [ ] **Repositories**
  - [ ] Data access methods
  - [ ] Query optimization
  - [ ] Caching integration
  - [ ] Error handling
  - [ ] Transaction support
  - [ ] Tests for repositories

#### 4. Cross-Cutting Concerns
- [ ] **Security**
  - [ ] Input sanitization
  - [ ] CSRF protection
  - [ ] Rate limiting
  - [ ] Data encryption
  - [ ] Security headers
  - [ ] Permission checks

- [ ] **Logging**
  - [ ] Request logging
  - [ ] Error logging
  - [ ] Audit logging
  - [ ] Performance logging

- [ ] **Utilities**
  - [ ] `/backend/src/utils/{{feature_name}}.utils.js`
  - [ ] Helper functions
  - [ ] Formatters
  - [ ] Common utilities
  - [ ] Tests for utilities

- [ ] **Configuration**
  - [ ] Feature flags
  - [ ] Environment variables
  - [ ] Configuration validation

### Database Changes
- [ ] **Schema Changes**
  - [ ] New tables/collections
  - [ ] Field additions
  - [ ] Index creation
  - [ ] Constraints
  - [ ] Migration scripts
  - [ ] Rollback scripts

- [ ] **Data Migration**
  - [ ] Data transformation scripts
  - [ ] Data validation
  - [ ] Migration testing

### Testing Strategy
- [ ] **Unit Tests**
  - [ ] Frontend component tests
  - [ ] Backend service tests
  - [ ] Utility function tests
  - [ ] Mock implementations

- [ ] **Integration Tests**
  - [ ] API endpoint tests
  - [ ] Database integration tests
  - [ ] External service integration tests

- [ ] **End-to-End Tests**
  - [ ] User flow tests
  - [ ] Edge case scenarios
  - [ ] Performance tests

- [ ] **Test Coverage**
  - [ ] Target: {{test_coverage_percentage}}%
  - [ ] Critical path coverage

### Documentation
- [ ] **API Documentation**
  - [ ] OpenAPI/Swagger definitions
  - [ ] Request/response examples
  - [ ] Error scenarios

- [ ] **Code Documentation**
  - [ ] Function/method documentation
  - [ ] Class/component documentation
  - [ ] Architecture documentation

- [ ] **User Documentation**
  - [ ] Usage guides
  - [ ] Screenshots
  - [ ] Example workflows

## Implementation Plan
- [ ] **Phase 1**: Data model and backend API implementation
- [ ] **Phase 2**: Frontend UI components and state management
- [ ] **Phase 3**: Integration and testing
- [ ] **Phase 4**: Documentation and polishing

## Delivery Checklist
- [ ] All code meets style guidelines
- [ ] Tests pass with required coverage
- [ ] Documentation is complete
- [ ] Feature flags configured
- [ ] Performance metrics meet requirements
- [ ] Security review completed
- [ ] Accessibility requirements met
- [ ] Cross-browser/device testing completed

Generate all necessary files following clean architecture patterns, with proper naming conventions, comprehensive documentation, and test coverage.
