const { Payment, User, Stream } = require('../models');

/**
 * @desc Create a tip payment
 * @route POST /api/payments/tip
 * @access Private
 */
exports.createTip = async (req, res) => {
  try {
    const { performerId, streamId, amount, paymentMethod } = req.body;
    const userId = req.user.id;
    
    // Check if performer exists
    const performer = await User.findOne({
      where: { id: performerId, role: 'performer' }
    });
    
    if (!performer) {
      return res.status(404).json({
        status: 'error',
        message: 'Performer not found'
      });
    }
    
    // Check if stream exists (if streamId is provided)
    if (streamId) {
      const stream = await Stream.findByPk(streamId);
      
      if (!stream) {
        return res.status(404).json({
          status: 'error',
          message: 'Stream not found'
        });
      }
      
      // Check if stream belongs to performer
      if (stream.performerId !== performerId) {
        return res.status(400).json({
          status: 'error',
          message: 'Stream does not belong to this performer'
        });
      }
    }
    
    // Prevent user from tipping themselves
    if (userId === performerId) {
      return res.status(400).json({
        status: 'error',
        message: 'You cannot tip yourself'
      });
    }
    
    // Create payment record
    const payment = await Payment.create({
      userId,
      performerId,
      streamId: streamId || null,
      amount,
      type: 'tip',
      status: 'pending',
      paymentMethod,
      metadata: {
        ipAddress: req.ip,
        userAgent: req.headers['user-agent']
      }
    });
    
    // TODO: Process payment with appropriate payment processor
    // This would involve calling a payment service based on the paymentMethod
    
    // For demo purposes, let's just mark it as completed
    payment.status = 'completed';
    await payment.save();
    
    // TODO: Emit socket event for real-time notification
    
    res.status(201).json({
      status: 'success',
      message: 'Tip payment created successfully',
      data: {
        payment: {
          id: payment.id,
          amount: payment.amount,
          type: payment.type,
          status: payment.status,
          createdAt: payment.createdAt
        }
      }
    });
  } catch (error) {
    console.error('Create tip error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Purchase a private show
 * @route POST /api/payments/private-show
 * @access Private
 */
exports.purchasePrivateShow = async (req, res) => {
  try {
    const { streamId, paymentMethod } = req.body;
    const userId = req.user.id;
    
    // Check if stream exists
    const stream = await Stream.findByPk(streamId, {
      include: [{
        model: User,
        as: 'performer',
        attributes: ['id', 'username']
      }]
    });
    
    if (!stream) {
      return res.status(404).json({
        status: 'error',
        message: 'Stream not found'
      });
    }
    
    // Check if stream is private
    if (!stream.isPrivate) {
      return res.status(400).json({
        status: 'error',
        message: 'This is not a private stream'
      });
    }
    
    // Check if user is not the performer (can't purchase own stream)
    if (userId === stream.performerId) {
      return res.status(400).json({
        status: 'error',
        message: 'You cannot purchase access to your own stream'
      });
    }
    
    // Create payment record
    const payment = await Payment.create({
      userId,
      performerId: stream.performerId,
      streamId,
      amount: stream.privatePrice,
      type: 'private_show',
      status: 'pending',
      paymentMethod,
      metadata: {
        ipAddress: req.ip,
        userAgent: req.headers['user-agent']
      }
    });
    
    // TODO: Process payment with appropriate payment processor
    // This would involve calling a payment service based on the paymentMethod
    
    // For demo purposes, let's just mark it as completed
    payment.status = 'completed';
    await payment.save();
    
    // TODO: Grant access to private stream
    
    res.status(201).json({
      status: 'success',
      message: 'Private show purchased successfully',
      data: {
        payment: {
          id: payment.id,
          amount: payment.amount,
          type: payment.type,
          status: payment.status,
          createdAt: payment.createdAt,
          stream: {
            id: stream.id,
            title: stream.title,
            performerId: stream.performerId,
            performerUsername: stream.performer.username
          }
        }
      }
    });
  } catch (error) {
    console.error('Purchase private show error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get payment history for current user
 * @route GET /api/payments/history
 * @access Private
 */
exports.getPaymentHistory = async (req, res) => {
  try {
    const { type, limit = 10, offset = 0 } = req.query;
    const userId = req.user.id;
    
    const query = {
      where: {
        userId
      },
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
        },
        {
          model: Stream,
          as: 'stream',
          attributes: ['id', 'title']
        }
      ]
    };
    
    // Filter by type if provided
    if (type) {
      query.where.type = type;
    }
    
    // Get payments
    const payments = await Payment.findAndCountAll(query);
    
    res.status(200).json({
      status: 'success',
      data: {
        payments: payments.rows,
        count: payments.count,
        limit: parseInt(limit, 10),
        offset: parseInt(offset, 10)
      }
    });
  } catch (error) {
    console.error('Get payment history error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get earnings for current performer
 * @route GET /api/payments/earnings
 * @access Private (Performer)
 */
exports.getEarnings = async (req, res) => {
  try {
    const { type, limit = 10, offset = 0 } = req.query;
    const user = req.user;
    
    // Check if user is a performer
    if (user.role !== 'performer') {
      return res.status(403).json({
        status: 'error',
        message: 'Only performers can access earnings'
      });
    }
    
    const query = {
      where: {
        performerId: user.id,
        status: 'completed'
      },
      limit: parseInt(limit, 10),
      offset: parseInt(offset, 10),
      order: [
        ['createdAt', 'DESC']
      ],
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'displayName', 'profilePicture']
        },
        {
          model: Stream,
          as: 'stream',
          attributes: ['id', 'title']
        }
      ]
    };
    
    // Filter by type if provided
    if (type) {
      query.where.type = type;
    }
    
    // Get payments
    const payments = await Payment.findAndCountAll(query);
    
    // Calculate total earnings
    const totalEarnings = payments.rows.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
    
    res.status(200).json({
      status: 'success',
      data: {
        payments: payments.rows,
        count: payments.count,
        limit: parseInt(limit, 10),
        offset: parseInt(offset, 10),
        totalEarnings
      }
    });
  } catch (error) {
    console.error('Get earnings error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get payment by ID
 * @route GET /api/payments/:id
 * @access Private
 */
exports.getPaymentById = async (req, res) => {
  try {
    const { id } = req.params;
    const user = req.user;
    
    // Get payment with related data
    const payment = await Payment.findByPk(id, {
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'displayName', 'profilePicture']
        },
        {
          model: User,
          as: 'performer',
          attributes: ['id', 'username', 'displayName', 'profilePicture']
        },
        {
          model: Stream,
          as: 'stream',
          attributes: ['id', 'title', 'status']
        }
      ]
    });
    
    if (!payment) {
      return res.status(404).json({
        status: 'error',
        message: 'Payment not found'
      });
    }
    
    // Check if user is authorized to view this payment
    if (user.id !== payment.userId && 
        user.id !== payment.performerId && 
        user.role !== 'admin') {
      return res.status(403).json({
        status: 'error',
        message: 'You are not authorized to view this payment'
      });
    }
    
    res.status(200).json({
      status: 'success',
      data: {
        payment
      }
    });
  } catch (error) {
    console.error('Get payment by ID error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};
