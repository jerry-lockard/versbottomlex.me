const jwt = require('jsonwebtoken');
const jwtConfig = require('../config/jwt');
const { User } = require('../models');
const logger = require('./logger');

/**
 * Authenticate socket connection with JWT
 * @param {Object} socket - Socket.io socket object
 * @param {Function} next - Socket.io next function
 */
const authenticateSocket = async (socket, next) => {
  try {
    // Get token from handshake query or headers
    const token = 
      socket.handshake.query?.token ||
      socket.handshake.auth?.token ||
      socket.handshake.headers?.authorization?.split(' ')[1];
    
    if (!token) {
      logger.warn('Socket connection without token attempted');
      return next(new Error('Authentication error'));
    }
    
    // Verify the token
    const decoded = jwt.verify(token, jwtConfig.secret, {
      issuer: jwtConfig.issuer,
      audience: jwtConfig.audience
    });
    
    // Get user from database
    const user = await User.findByPk(decoded.id, {
      attributes: { exclude: ['password'] }
    });
    
    if (!user) {
      logger.warn(`Socket auth failed: User not found, ID: ${decoded.id}`);
      return next(new Error('Authentication error'));
    }
    
    // Check token version
    if (user.tokenVersion !== decoded.tokenVersion) {
      logger.warn(`Socket auth failed: Token version mismatch for user ${user.id}`);
      return next(new Error('Token expired'));
    }
    
    // Add user data to socket
    socket.user = user;
    socket.userId = user.id;
    socket.rooms = new Set();
    
    next();
  } catch (error) {
    logger.error('Socket authentication error:', error);
    next(new Error('Authentication error'));
  }
};

/**
 * Initialize Socket.io connections and event handlers
 * @param {Object} io - Socket.io server instance
 */
const initializeSocketIO = (io) => {
  // Apply authentication middleware
  io.use(authenticateSocket);
  
  io.on('connection', (socket) => {
    const { id, user } = socket;
    
    logger.info(`Socket connected: ${id}, User: ${user.username}`);
    
    // Track rooms this socket has joined
    const joinedRooms = new Set();
    
    // Join a stream room
    socket.on('joinRoom', (streamId) => {
      if (!streamId) return;
      
      socket.join(streamId);
      joinedRooms.add(streamId);
      
      logger.debug(`User ${user.username} joined room: ${streamId}`);
      
      // Notify room that user joined
      io.to(streamId).emit('userJoined', {
        userId: user.id,
        username: user.username,
        timestamp: new Date(),
      });
    });
    
    // Leave a stream room
    socket.on('leaveRoom', (streamId) => {
      if (!streamId || !joinedRooms.has(streamId)) return;
      
      socket.leave(streamId);
      joinedRooms.delete(streamId);
      
      logger.debug(`User ${user.username} left room: ${streamId}`);
      
      // Notify room that user left
      io.to(streamId).emit('userLeft', {
        userId: user.id,
        username: user.username,
        timestamp: new Date(),
      });
    });
    
    // Chat message handler
    socket.on('chatMessage', (data) => {
      // Validate message data
      if (!data || !data.streamId || !data.message) return;
      
      // Ensure user is in the room they're sending to
      if (!joinedRooms.has(data.streamId)) {
        return socket.emit('error', { message: 'You must join this room first' });
      }
      
      // Rate limiting could be implemented here
      
      // Create a sanitized message object
      const messageObject = {
        userId: user.id,
        username: user.username,
        message: data.message.substring(0, 500), // Limit message length
        timestamp: new Date(),
      };
      
      // Broadcast message to room
      io.to(data.streamId).emit('chatMessage', messageObject);
      
      // Here you could also save message to database
    });
    
    // Handle tip events
    socket.on('tipReceived', (data) => {
      // Validate tip data
      if (!data || !data.streamId || !data.amount || data.amount <= 0) return;
      
      // Security: in production, tips should be verified through a secure channel
      // This would typically be done through the payment controller, not directly via socket
      
      const tipObject = {
        userId: user.id,
        username: user.username,
        amount: data.amount,
        message: data.message?.substring(0, 200) || '',
        timestamp: new Date(),
      };
      
      io.to(data.streamId).emit('tipReceived', tipObject);
    });
    
    // Handle stream status updates
    socket.on('streamUpdate', (data) => {
      // In production, this should verify the user is the owner of the stream
      if (!data || !data.streamId || !data.status) return;
      
      // Typically would verify user permissions here
      
      io.to(data.streamId).emit('streamUpdate', {
        streamId: data.streamId,
        status: data.status,
        message: data.message || null,
        timestamp: new Date()
      });
    });
    
    // Disconnect handler
    socket.on('disconnect', () => {
      logger.info(`Socket disconnected: ${id}, User: ${user.username}`);
      
      // Notify all rooms this user was in
      joinedRooms.forEach(roomId => {
        io.to(roomId).emit('userLeft', {
          userId: user.id,
          username: user.username,
          timestamp: new Date()
        });
      });
    });
  });
};

module.exports = { authenticateSocket, initializeSocketIO };