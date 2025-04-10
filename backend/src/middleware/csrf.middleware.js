const Tokens = require('csrf');
const logger = require('../utils/logger');

const tokens = new Tokens();

/**
 * Generate a new CSRF token for a user session
 * @param {string} sessionId - An identifier for the user session
 * @returns {Object} - Object containing secret and token
 */
const generateCsrfToken = (sessionId) => {
  try {
    // Create a unique secret based on the session ID
    const secret = tokens.secretSync();
    // Create a token using the secret
    const token = tokens.create(secret);
    
    return { secret, token };
  } catch (error) {
    logger.error('Error generating CSRF token:', error);
    throw new Error('Failed to generate security token');
  }
};

/**
 * Verify a CSRF token against a secret
 * @param {string} token - The CSRF token to verify
 * @param {string} secret - The secret used to create the token
 * @returns {boolean} - Whether the token is valid
 */
const verifyCsrfToken = (token, secret) => {
  try {
    return tokens.verify(secret, token);
  } catch (error) {
    logger.error('Error verifying CSRF token:', error);
    return false;
  }
};

/**
 * Middleware to check CSRF token in headers
 * This would be used for API routes that need CSRF protection
 */
const csrfProtection = (req, res, next) => {
  // Skip CSRF check for GET requests (they should be idempotent)
  if (req.method === 'GET') {
    return next();
  }
  
  try {
    // The secret should be stored in the user's session
    // For this example, we'll assume it's in req.session.csrfSecret
    const secret = req.session?.csrfSecret;
    const token = req.headers['x-csrf-token'];
    
    if (!secret || !token) {
      logger.warn(`CSRF validation failed: ${!secret ? 'No secret' : 'No token'} provided`);
      return res.status(403).json({
        status: 'error',
        message: 'CSRF validation failed'
      });
    }
    
    // Verify the token
    if (!verifyCsrfToken(token, secret)) {
      logger.warn(`CSRF token validation failed for IP: ${req.ip}`);
      return res.status(403).json({
        status: 'error',
        message: 'Invalid security token'
      });
    }
    
    next();
  } catch (error) {
    logger.error('CSRF middleware error:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Security validation error'
    });
  }
};

module.exports = {
  generateCsrfToken,
  verifyCsrfToken,
  csrfProtection
};