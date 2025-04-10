const logger = require('../utils/logger');

// Check for required environment variables
if (!process.env.JWT_SECRET) {
  logger.error('JWT_SECRET is missing. Set this environment variable for security.');
  process.exit(1);
}

if (!process.env.JWT_REFRESH_SECRET) {
  logger.error('JWT_REFRESH_SECRET is missing. Set this environment variable for security.');
  process.exit(1);
}

module.exports = {
  secret: process.env.JWT_SECRET,
  refreshSecret: process.env.JWT_REFRESH_SECRET, // Separate secret for refresh tokens
  expiresIn: process.env.JWT_EXPIRES_IN || '15m', // Shorter expiry for access tokens
  refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  issuer: process.env.JWT_ISSUER || 'example.com',
  audience: process.env.JWT_AUDIENCE || 'app-api',
};