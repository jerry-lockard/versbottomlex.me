const { Sequelize } = require('sequelize');
const logger = require('../utils/logger');

// Check for required environment variables
if (!process.env.DB_NAME || !process.env.DB_USER || !process.env.DB_PASSWORD) {
  logger.error('Database configuration missing. Check environment variables.');
  process.exit(1);
}

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development' ? msg => logger.debug(msg) : false,
    pool: {
      max: parseInt(process.env.DB_POOL_MAX || '5', 10),
      min: parseInt(process.env.DB_POOL_MIN || '0', 10),
      acquire: parseInt(process.env.DB_POOL_ACQUIRE || '30000', 10),
      idle: parseInt(process.env.DB_POOL_IDLE || '10000', 10),
    },
    retry: {
      max: 3,
      match: [/Deadlock/i, /Lock/i, /Timeout/i],
    },
  },
);

// Database connection handler
const connectToDatabase = async () => {
  try {
    await sequelize.authenticate();
    logger.info('Database connection established successfully');
    return true;
  } catch (error) {
    logger.error('Unable to connect to the database:', error.message);
    return false;
  }
};

module.exports = {
  sequelize,
  connectToDatabase,
};