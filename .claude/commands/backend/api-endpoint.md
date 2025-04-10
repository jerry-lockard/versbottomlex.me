# Node.js API Endpoint Generator

Create a production-ready RESTful API endpoint for the VersBottomLex.me backend following our architecture patterns.

## Endpoint Specification
- **Path**: `{{endpoint_path}}`
- **HTTP Method**: `{{GET|POST|PUT|DELETE|PATCH}}`
- **Controller**: `src/controllers/{{controller_name}}.controller.js`
- **Route File**: `src/routes/{{route_file}}.routes.js`
- **Purpose**: {{purpose}}

## Authentication & Authorization
- **Requires Auth**: `{{Yes|No}}`
- **Auth Type**: `{{JWT|API Key|None}}`
- **Required Role**: `{{user|admin|streamer|moderator|any}}`

## Request Details
### Headers
- Content-Type: `{{content_type}}`
- Accept: `application/json`

### Parameters
| Name | Type | Required | Location | Description |
|------|------|----------|----------|-------------|
{{request_parameters}}

### Request Body
```json
{
  {{request_body_example}}
}
```

## Response Details
### Success Response ({{status_code}})
```json
{
  {{success_response_example}}
}
```

### Error Responses
| Status | Description | Example |
|--------|-------------|---------|
| 400 | Bad Request | `{"error": "Invalid parameters"}` |
| 401 | Unauthorized | `{"error": "Authentication required"}` |
| 403 | Forbidden | `{"error": "Insufficient permissions"}` |
| 404 | Not Found | `{"error": "Resource not found"}` |
| 500 | Server Error | `{"error": "Internal server error"}` |

## Implementation Requirements
- [ ] Use Express Router and Controller pattern
- [ ] Implement input validation using middleware
- [ ] Apply proper error handling with api-error.js
- [ ] Add comprehensive logging with logger.js
- [ ] Document with JSDoc comments
- [ ] Write unit tests in `/backend/tests/`
- [ ] Respect RESTful principles
- [ ] Add rate limiting for public endpoints

## Database Interactions
- **Models**: `{{model_name}}.model.js`
- **Operations**: `{{create|read|update|delete|query}}`
- **Transactions**: `{{Yes|No}}`
