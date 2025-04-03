require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

// Import routes
const authRoutes = require('./routes/auth.routes');
const streamRoutes = require('./routes/stream.routes');
const paymentRoutes = require('./routes/payment.routes');
const userRoutes = require('./routes/user.routes');

// Database connection
const db = require('./config/database');

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
    origin: process.env.FRONTEND_URL || 'http://localhost:8080',
    methods: ['GET', 'POST'],
    credentials: true,
  },
});

// Middleware
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

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

// Socket.io events
io.on('connection', (socket) => {
  console.log('New client connected', socket.id);

  socket.on('joinRoom', (streamId) => {
    socket.join(streamId);
    console.log(`Client ${socket.id} joined room: ${streamId}`);
  });

  socket.on('leaveRoom', (streamId) => {
    socket.leave(streamId);
    console.log(`Client ${socket.id} left room: ${streamId}`);
  });

  socket.on('chatMessage', (data) => {
    io.to(data.streamId).emit('chatMessage', {
      userId: data.userId,
      username: data.username,
      message: data.message,
      timestamp: new Date(),
    });
  });

  socket.on('tipReceived', (data) => {
    io.to(data.streamId).emit('tipReceived', {
      userId: data.userId,
      username: data.username,
      amount: data.amount,
      timestamp: new Date(),
    });
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected', socket.id);
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    status: 'error',
    message: 'Internal Server Error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined,
  });
});

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, async () => {
  console.log(`Server running on port ${PORT}`);
  
  try {
    await db.authenticate();
    console.log('Database connection has been established successfully.');
    // Sync database models
    // await db.sync({ force: false });
    // console.log('Database models synchronized.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});

module.exports = { app, server, io };