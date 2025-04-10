# Database Schema Design for VersBottomLex.me

Design a comprehensive, normalized, and scalable database schema for our streaming platform, optimized for performance, security, and future growth.

## Project Requirements
- **Database Type**: `{{PostgreSQL|MongoDB|MySQL|Other}}`
- **Schema Name**: `{{schema_name}}`
- **Primary Focus**: `{{streaming|payments|analytics|user_management}}`
- **Expected Data Volume**: `{{small|medium|large|enterprise}}`
- **Read/Write Ratio**: `{{read_heavy|write_heavy|balanced}}`

## Core Entities Design

### User Management
- [ ] **Users Table**:
  - Define comprehensive user profile fields
  - Include authentication fields
  - Add role-based access control
  - Design for user preferences
  - Account status and moderation flags

- [ ] **Performer Profiles**:
  - Streaming preferences and settings
  - Performance categories and tags
  - Payout information (tokenized/encrypted)
  - Schedule and availability
  - Performance metrics

- [ ] **Viewer Profiles**:
  - Subscription management
  - Viewing preferences
  - Payment methods (tokenized/encrypted)
  - Favorites and follow relationships
  - Notification settings

### Content Management
- [ ] **Streams Table**:
  - Stream metadata (title, description, thumbnail)
  - Technical configuration
  - Visibility and access control
  - Categorization and tagging
  - Metrics and status

- [ ] **Stream Archives**:
  - Recording references
  - Playback configuration
  - Content moderation status
  - Access control
  - Retention policy

- [ ] **Categories and Tags**:
  - Hierarchical category structure
  - Tag management
  - Content classification
  - Searchability optimizations

### Financial System
- [ ] **Transactions Table**:
  - Payment processing records
  - Subscription management
  - Tipping/donation tracking
  - Revenue sharing calculations
  - Financial compliance data

- [ ] **Payment Methods**:
  - Secure payment instrument storage
  - Provider integration details
  - Verification status
  - Usage history

- [ ] **Pricing Plans**:
  - Subscription tiers
  - Pay-per-view options
  - Special offers and promotions
  - Regional pricing

### Interaction System
- [ ] **Messages Table**:
  - Public and private communication
  - Message content and metadata
  - Moderation status
  - Attachment handling

- [ ] **Reactions and Engagement**:
  - Likes, follows, shares
  - Tipping/gifting records
  - Viewer engagement metrics
  - Interactive features data

- [ ] **Notifications**:
  - Event triggers
  - Delivery status
  - User preferences
  - Template management

### Analytics and Reporting
- [ ] **Performance Metrics**:
  - Stream performance data
  - Revenue analytics
  - Audience demographics
  - Engagement statistics
  - Retention metrics

- [ ] **Audit Logs**:
  - Security events
  - Administrative actions
  - System operations
  - Compliance tracking

## Implementation Details
- [ ] **Table Definitions**:
  - Column names and data types
  - Primary keys and unique constraints
  - Foreign key relationships
  - Default values and constraints
  - Indexing strategy

- [ ] **Data Integrity**:
  - Constraints and validation rules
  - Referential integrity
  - Cascading updates/deletes
  - Soft deletion pattern

- [ ] **Performance Optimization**:
  - Indexing strategy
  - Partitioning plan
  - Query optimization considerations
  - Caching recommendations

- [ ] **Security Measures**:
  - Data encryption requirements
  - PII/sensitive data handling
  - Role-based access controls
  - Row-level security

## Documentation Deliverables
1. Complete schema diagram (ERD)
2. Detailed table definitions with comments
3. Example queries for common operations
4. Indexing and performance recommendations
5. Migration and versioning strategy

Design a robust database schema that supports all platform requirements while maintaining flexibility for future growth and changes.
