require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const session = require('express-session');
const { randomBytes } = require('crypto');

// Import logger
const logger = require('./utils/logger');

// Import routes
const authRoutes = require('./routes/auth.routes');
const streamRoutes = require('./routes/stream.routes');
const paymentRoutes = require('./routes/payment.routes');
const userRoutes = require('./routes/user.routes');

// Import rate limiter middleware
const { globalLimiter } = require('./middleware/rate-limit.middleware');

// Database connection
const { sequelize, connectToDatabase } = require('./config/database');

// Swagger configuration
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'VersBottomLex.me API',
      version: '1.0.0',
      description: 'API documentation for VersBottomLex.me webcam platform',
    },
    servers: [
      {
        url: process.env.API_URL || 'http://localhost:3000',
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/routes/*.js'],
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);

// Initialize Express app
const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: process.env.FRONTEND_URL || 'http://localhost:3000',
    methods: ['GET', 'POST'],
    credentials: true,
  },
});

// Set up session middleware (before other middleware)
const sessionConfig = {
  secret: process.env.SESSION_SECRET || randomBytes(32).toString('hex'),
  name: 'vbl.sid',
  cookie: {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production', // Only set secure to true in production (requires HTTPS)
    sameSite: 'strict',
    maxAge: 1000 * 60 * 60 * 24 * 7 // 1 week
  },
  resave: false,
  saveUninitialized: false
};

// In production, you should use a proper session store like Redis
if (process.env.NODE_ENV === 'production') {
  // SessionStore setup would go here
  // Example: const RedisStore = require('connect-redis')(session);
  // sessionConfig.store = new RedisStore({ client: redisClient });
  
  // Also ensure the cookie security settings are strict in production
  sessionConfig.cookie.secure = true;
}

// Middleware
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  credentials: true,
  allowedHeaders: ['Content-Type', 'Authorization', 'X-CSRF-Token']
}));

// Apply Helmet for security headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"], // Modify as needed for your specific requirements
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },
  xssFilter: true,
  noSniff: true,
  referrerPolicy: { policy: 'same-origin' }
}));

// Apply global rate limiter
app.use(globalLimiter);

// Setup session
app.use(session(sessionConfig));

// Logging middleware
app.use(morgan('combined', {
  stream: {
    write: (message) => {
      logger.info(message.trim());
    }
  }
}));

app.use(express.json({ limit: '1mb' })); // Limit request size
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

// API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/streams', streamRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/users', userRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is running' });
});

// Initialize Socket.io with authentication and event handlers
const { initializeSocketIO } = require('./utils/socket.utils');
initializeSocketIO(io);

// Add request ID middleware for tracking requests
app.use((req, res, next) => {
  req.id = randomBytes(8).toString('hex');
  res.setHeader('X-Request-ID', req.id);
  next();
});

// CSRF token endpoint - provides a new token when needed
app.get('/api/csrf-token', (req, res) => {
  const { generateCsrfToken } = require('./middleware/csrf.middleware');
  const { secret, token } = generateCsrfToken(req.sessionID);
  
  // Store the secret in the session
  req.session.csrfSecret = secret;
  
  res.json({ token });
});

// Error handling middleware
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  logger.error(`Error [${req.id}]: ${err.message}`, {
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    ip: req.ip
  });
  
  res.status(statusCode).json({
    status: 'error',
    message: statusCode === 500 ? 'Internal Server Error' : err.message,
    error: process.env.NODE_ENV === 'development' ? err.message : undefined,
    requestId: req.id // Include for error tracking
  });
});

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, async () => {
  logger.info(`Server starting on port ${PORT}`);
  
  try {
    // Attempt to connect to the database with retry mechanism
    let connected = false;
    let attempts = 0;
    const maxAttempts = 5;
    
    while (!connected && attempts < maxAttempts) {
      attempts++;
      connected = await connectToDatabase();
      
      if (!connected && attempts < maxAttempts) {
        const delay = attempts * 2000; // Exponential backoff
        logger.warn(`Database connection attempt ${attempts} failed. Retrying in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
    
    if (connected) {
      // Sync database models if successfully connected
      // For production, you should use migrations instead of sync
      if (process.env.NODE_ENV === 'development') {
        await sequelize.sync({ alter: true });
        logger.info('Database models synchronized');
      }
      
      logger.info('Server is now ready to accept connections');
    } else {
      logger.error(`Failed to connect to database after ${maxAttempts} attempts`);
      // In production, you might want to exit the process here
      // process.exit(1);
    }
  } catch (error) {
    logger.error('Server startup error:', error);
  }
});

module.exports = { app, server, io };