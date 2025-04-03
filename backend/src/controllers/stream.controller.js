const { Stream, User, Message } = require('../models');
const { v4: uuidv4 } = require('uuid');

/**
 * @desc Get all streams
 * @route GET /api/streams
 * @access Public
 */
exports.getAllStreams = async (req, res) => {
  try {
    const { status, limit = 10, offset = 0 } = req.query;
    
    const query = {
      where: {},
      limit: parseInt(limit, 10),
      offset: parseInt(offset, 10),
      order: [
        ['createdAt', 'DESC']
      ],
      include: [
        {
          model: User,
          as: 'performer',
          attributes: ['id', 'username', 'displayName', 'profilePicture']
        }
      ]
    };
    
    // Filter by status if provided
    if (status) {
      query.where.status = status;
    }
    
    // Only show public streams
    query.where.isPrivate = false;
    
    const streams = await Stream.findAndCountAll(query);
    
    res.status(200).json({
      status: 'success',
      data: {
        streams: streams.rows,
        count: streams.count,
        limit: parseInt(limit, 10),
        offset: parseInt(offset, 10)
      }
    });
  } catch (error) {
    console.error('Get all streams error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get stream by ID
 * @route GET /api/streams/:id
 * @access Public
 */
exports.getStreamById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const stream = await Stream.findByPk(id, {
      include: [
        {
          model: User,
          as: 'performer',
          attributes: ['id', 'username', 'displayName', 'profilePicture']
        }
      ]
    });
    
    if (!stream) {
      return res.status(404).json({
        status: 'error',
        message: 'Stream not found'
      });
    }
    
    // Check if stream is private and user is authorized
    if (stream.isPrivate) {
      // If user is not authenticated
      if (!req.user) {
        return res.status(403).json({
          status: 'error',
          message: 'This is a private stream'
        });
      }
      
      // If user is not the performer or an admin
      if (req.user.id !== stream.performerId && req.user.role !== 'admin') {
        // TODO: Check if user has purchased access to this private stream
        // For now, just return forbidden
        return res.status(403).json({
          status: 'error',
          message: 'Access to this private stream requires payment'
        });
      }
    }
    
    // Increment viewer count if stream is live
    if (stream.status === 'live') {
      stream.viewerCount += 1;
      await stream.save();
    }
    
    res.status(200).json({
      status: 'success',
      data: {
        stream
      }
    });
  } catch (error) {
    console.error('Get stream by ID error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Create a new stream
 * @route POST /api/streams
 * @access Private (Performer, Admin)
 */
exports.createStream = async (req, res) => {
  try {
    const { title, description, scheduledStartTime, isPrivate, privatePrice } = req.body;
    const user = req.user;
    
    // Generate unique stream key
    const streamKey = uuidv4();
    
    // Create stream
    const stream = await Stream.create({
      title,
      description,
      scheduledStartTime,
      isPrivate: isPrivate || false,
      privatePrice: isPrivate ? privatePrice : null,
      performerId: user.id,
      streamKey,
      rtmpUrl: `${process.env.RTMP_SERVER_URL}/${streamKey}`,
      status: 'scheduled'
    });
    
    res.status(201).json({
      status: 'success',
      message: 'Stream created successfully',
      data: {
        stream
      }
    });
  } catch (error) {
    console.error('Create stream error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Update a stream
 * @route PUT /api/streams/:id
 * @access Private (Owner, Admin)
 */
exports.updateStream = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, scheduledStartTime, isPrivate, privatePrice } = req.body;
    
    // Stream has already been fetched in the checkOwnership middleware
    const stream = req.resource;
    
    // Check if stream is in progress
    if (stream.status === 'live') {
      // Only allow certain updates when stream is live
      if (title) stream.title = title;
      if (description) stream.description = description;
      
      // Cannot change scheduledStartTime, isPrivate, privatePrice when stream is live
    } else {
      // Full update when stream is not live
      if (title) stream.title = title;
      if (description !== undefined) stream.description = description;
      if (scheduledStartTime) stream.scheduledStartTime = scheduledStartTime;
      if (isPrivate !== undefined) {
        stream.isPrivate = isPrivate;
        // If making it private, ensure there's a price
        if (isPrivate && privatePrice) {
          stream.privatePrice = privatePrice;
        } else if (!isPrivate) {
          stream.privatePrice = null;
        }
      }
    }
    
    await stream.save();
    
    res.status(200).json({
      status: 'success',
      message: 'Stream updated successfully',
      data: {
        stream
      }
    });
  } catch (error) {
    console.error('Update stream error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Start a stream
 * @route POST /api/streams/:id/start
 * @access Private (Owner, Admin)
 */
exports.startStream = async (req, res) => {
  try {
    // Stream has already been fetched in the checkOwnership middleware
    const stream = req.resource;
    
    // Check if stream is already live
    if (stream.status === 'live') {
      return res.status(400).json({
        status: 'error',
        message: 'Stream is already live'
      });
    }
    
    // Check if stream has ended
    if (stream.status === 'ended') {
      return res.status(400).json({
        status: 'error',
        message: 'Cannot restart an ended stream'
      });
    }
    
    // Update stream status
    stream.status = 'live';
    stream.actualStartTime = new Date();
    await stream.save();
    
    res.status(200).json({
      status: 'success',
      message: 'Stream started successfully',
      data: {
        stream
      }
    });
  } catch (error) {
    console.error('Start stream error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc End a stream
 * @route POST /api/streams/:id/end
 * @access Private (Owner, Admin)
 */
exports.endStream = async (req, res) => {
  try {
    // Stream has already been fetched in the checkOwnership middleware
    const stream = req.resource;
    
    // Check if stream is not live
    if (stream.status !== 'live') {
      return res.status(400).json({
        status: 'error',
        message: 'Stream is not live'
      });
    }
    
    // Update stream status
    stream.status = 'ended';
    stream.endTime = new Date();
    await stream.save();
    
    res.status(200).json({
      status: 'success',
      message: 'Stream ended successfully',
      data: {
        stream
      }
    });
  } catch (error) {
    console.error('End stream error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get messages for a stream
 * @route GET /api/streams/:id/messages
 * @access Public
 */
exports.getStreamMessages = async (req, res) => {
  try {
    const { id } = req.params;
    const { limit = 50, offset = 0 } = req.query;
    
    // Check if stream exists
    const stream = await Stream.findByPk(id);
    if (!stream) {
      return res.status(404).json({
        status: 'error',
        message: 'Stream not found'
      });
    }
    
    // Check if stream is private and user is authorized
    if (stream.isPrivate) {
      // If user is not authenticated
      if (!req.user) {
        return res.status(403).json({
          status: 'error',
          message: 'This is a private stream'
        });
      }
      
      // If user is not the performer or an admin
      if (req.user.id !== stream.performerId && req.user.role !== 'admin') {
        // TODO: Check if user has purchased access to this private stream
        // For now, just return forbidden
        return res.status(403).json({
          status: 'error',
          message: 'Access to this private stream requires payment'
        });
      }
    }
    
    // Get messages for the stream
    const messages = await Message.findAndCountAll({
      where: {
        streamId: id,
        isDeleted: false
      },
      limit: parseInt(limit, 10),
      offset: parseInt(offset, 10),
      order: [
        ['createdAt', 'ASC']
      ],
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'displayName', 'profilePicture', 'role']
        }
      ]
    });
    
    res.status(200).json({
      status: 'success',
      data: {
        messages: messages.rows,
        count: messages.count,
        limit: parseInt(limit, 10),
        offset: parseInt(offset, 10)
      }
    });
  } catch (error) {
    console.error('Get stream messages error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Send a message to a stream
 * @route POST /api/streams/:id/messages
 * @access Private
 */
exports.sendMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;
    const user = req.user;
    
    // Check if stream exists
    const stream = await Stream.findByPk(id);
    if (!stream) {
      return res.status(404).json({
        status: 'error',
        message: 'Stream not found'
      });
    }
    
    // Check if stream is live
    if (stream.status !== 'live') {
      return res.status(400).json({
        status: 'error',
        message: 'Cannot send messages to a stream that is not live'
      });
    }
    
    // Check if stream is private and user is authorized
    if (stream.isPrivate) {
      // If user is not the performer or an admin
      if (user.id !== stream.performerId && user.role !== 'admin') {
        // TODO: Check if user has purchased access to this private stream
        // For now, just return forbidden
        return res.status(403).json({
          status: 'error',
          message: 'Access to this private stream requires payment'
        });
      }
    }
    
    // Create the message
    const message = await Message.create({
      content,
      userId: user.id,
      streamId: id
    });
    
    // Get the message with user data
    const messageWithUser = await Message.findByPk(message.id, {
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'displayName', 'profilePicture', 'role']
        }
      ]
    });
    
    // TODO: Emit socket event for real-time updates
    
    res.status(201).json({
      status: 'success',
      message: 'Message sent successfully',
      data: {
        message: messageWithUser
      }
    });
  } catch (error) {
    console.error('Send message error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};