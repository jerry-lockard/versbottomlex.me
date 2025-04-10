const rateLimit = require('express-rate-limit');
const logger = require('../utils/logger');

/**
 * Create rate limiter with custom configuration
 * @param {Object} options - Rate limiter options
 */
const createRateLimiter = (options = {}) => {
  const defaultOptions = {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // Limit each IP to 100 requests per window
    standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
    legacyHeaders: false, // Disable the `X-RateLimit-*` headers
    handler: (req, res, next, options) => {
      logger.warn(`Rate limit exceeded for IP: ${req.ip}`);
      res.status(options.statusCode).json({
        status: 'error',
        message: options.message || 'Too many requests, please try again later.'
      });
    },
  };

  return rateLimit({
    ...defaultOptions,
    ...options,
  });
};

// Global rate limiter
const globalLimiter = createRateLimiter();

// More strict limiter for authentication endpoints
const authLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // 10 attempts per window
  message: 'Too many login attempts, please try again after 15 minutes',
});

// Stricter limiter for sensitive operations
const sensitiveOpLimiter = createRateLimiter({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // 5 attempts per hour
  message: 'Too many attempts, please try again after 1 hour',
});

module.exports = {
  globalLimiter,
  authLimiter,
  sensitiveOpLimiter,
};