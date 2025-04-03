module.exports = {
  secret: process.env.JWT_SECRET || 'versBottomLex_secret_key',
  expiresIn: process.env.JWT_EXPIRES_IN || '1h',
  refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
};