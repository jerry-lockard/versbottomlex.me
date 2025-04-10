/**
 * Logger utility for consistent logging across the application
 */

const LOG_LEVELS = {
  ERROR: 0,
  WARN: 1,
  INFO: 2,
  DEBUG: 3,
};

// Set default log level based on environment
const currentLogLevel = process.env.LOG_LEVEL
  ? LOG_LEVELS[process.env.LOG_LEVEL.toUpperCase()] || LOG_LEVELS.INFO
  : process.env.NODE_ENV === 'production' 
    ? LOG_LEVELS.INFO 
    : LOG_LEVELS.DEBUG;

/**
 * Format log message with timestamp, level and optional data
 */
const formatLogMessage = (level, message, data) => {
  const timestamp = new Date().toISOString();
  let logObject = {
    timestamp,
    level,
    message,
  };

  if (data) {
    // Ensure we don't log sensitive information
    const sensitiveFields = ['password', 'token', 'secret', 'creditCard'];
    
    if (typeof data === 'object' && data !== null) {
      // Create a deep copy to avoid modifying the original object
      const sanitizedData = JSON.parse(JSON.stringify(data));
      
      // Recursively sanitize the object
      const sanitize = (obj) => {
        Object.keys(obj).forEach(key => {
          if (sensitiveFields.some(field => key.toLowerCase().includes(field.toLowerCase()))) {
            obj[key] = '[REDACTED]';
          } else if (typeof obj[key] === 'object' && obj[key] !== null) {
            sanitize(obj[key]);
          }
        });
      };

      sanitize(sanitizedData);
      logObject.data = sanitizedData;
    } else {
      logObject.data = data;
    }
  }

  return logObject;
};

/**
 * Core logging function
 */
const log = (level, levelValue, message, data) => {
  if (levelValue > currentLogLevel) return;

  const logObject = formatLogMessage(level, message, data);
  
  // In production, we could replace this with a proper logging service
  switch (levelValue) {
    case LOG_LEVELS.ERROR:
      console.error(JSON.stringify(logObject));
      break;
    case LOG_LEVELS.WARN:
      console.warn(JSON.stringify(logObject));
      break;
    case LOG_LEVELS.INFO:
      console.info(JSON.stringify(logObject));
      break;
    default:
      console.log(JSON.stringify(logObject));
  }
};

module.exports = {
  error: (message, data) => log('ERROR', LOG_LEVELS.ERROR, message, data),
  warn: (message, data) => log('WARN', LOG_LEVELS.WARN, message, data),
  info: (message, data) => log('INFO', LOG_LEVELS.INFO, message, data),
  debug: (message, data) => log('DEBUG', LOG_LEVELS.DEBUG, message, data),
};
