/**
 * Custom API Error class for consistent error handling
 */
class ApiError extends Error {
  /**
   * Create a new API error
   * @param {string} message - Error message
   * @param {number} statusCode - HTTP status code
   * @param {Object} details - Additional error details
   */
  constructor(message, statusCode = 500, details = null) {
    super(message);
    this.statusCode = statusCode;
    this.details = details;
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
  
  /**
   * Create a 400 Bad Request error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static badRequest(message = 'Bad Request', details = null) {
    return new ApiError(message, 400, details);
  }
  
  /**
   * Create a 401 Unauthorized error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static unauthorized(message = 'Unauthorized', details = null) {
    return new ApiError(message, 401, details);
  }
  
  /**
   * Create a 403 Forbidden error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static forbidden(message = 'Forbidden', details = null) {
    return new ApiError(message, 403, details);
  }
  
  /**
   * Create a 404 Not Found error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static notFound(message = 'Resource not found', details = null) {
    return new ApiError(message, 404, details);
  }
  
  /**
   * Create a 409 Conflict error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static conflict(message = 'Resource conflict', details = null) {
    return new ApiError(message, 409, details);
  }
  
  /**
   * Create a 422 Unprocessable Entity error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static validationError(message = 'Validation failed', details = null) {
    return new ApiError(message, 422, details);
  }
  
  /**
   * Create a 429 Too Many Requests error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static tooManyRequests(message = 'Too many requests', details = null) {
    return new ApiError(message, 429, details);
  }
  
  /**
   * Create a 500 Internal Server Error
   * @param {string} message - Error message
   * @param {Object} details - Additional error details
   * @returns {ApiError} - New API error instance
   */
  static internal(message = 'Internal server error', details = null) {
    return new ApiError(message, 500, details);
  }
}

module.exports = ApiError;