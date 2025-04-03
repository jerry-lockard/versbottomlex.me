const { User, Stream } = require('../models');

/**
 * @desc Get user profile by ID
 * @route GET /api/users/:id
 * @access Public
 */
exports.getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Find user
    const user = await User.findByPk(id, {
      attributes: { exclude: ['password', 'tokenVersion'] }
    });
    
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    res.status(200).json({
      status: 'success',
      data: {
        user
      }
    });
  } catch (error) {
    console.error('Get user by ID error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Get streams by user ID
 * @route GET /api/users/:id/streams
 * @access Public
 */
exports.getUserStreams = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, limit = 10, offset = 0 } = req.query;
    
    // Check if user exists and is a performer
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    if (user.role !== 'performer') {
      return res.status(400).json({
        status: 'error',
        message: 'User is not a performer'
      });
    }
    
    // Query parameters
    const query = {
      where: {
        performerId: id
      },
      limit: parseInt(limit, 10),
      offset: parseInt(offset, 10),
      order: [
        ['createdAt', 'DESC']
      ]
    };
    
    // Filter by status if provided
    if (status) {
      query.where.status = status;
    }
    
    // If user is not authenticated, show only public streams
    if (!req.user) {
      query.where.isPrivate = false;
    } else if (req.user.id !== id && req.user.role !== 'admin') {
      // If user is authenticated but not the performer or admin, show only public streams
      query.where.isPrivate = false;
    }
    
    // Get streams
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
    console.error('Get user streams error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Update user profile
 * @route PUT /api/users/profile
 * @access Private
 */
exports.updateProfile = async (req, res) => {
  try {
    const { displayName, bio, profilePicture } = req.body;
    const user = req.user;
    
    // Update profile fields
    if (displayName !== undefined) user.displayName = displayName;
    if (bio !== undefined) user.bio = bio;
    if (profilePicture !== undefined) user.profilePicture = profilePicture;
    
    await user.save();
    
    // Return updated user (excluding password)
    const userData = user.toJSON();
    delete userData.password;
    delete userData.tokenVersion;
    
    res.status(200).json({
      status: 'success',
      message: 'Profile updated successfully',
      data: {
        user: userData
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Delete user account
 * @route DELETE /api/users/:id
 * @access Private
 */
exports.deleteAccount = async (req, res) => {
  try {
    const { id } = req.params;
    const currentUser = req.user;
    
    // Only allow users to delete their own account or admins to delete any account
    if (currentUser.id !== id && currentUser.role !== 'admin') {
      return res.status(403).json({
        status: 'error',
        message: 'You are not authorized to delete this account'
      });
    }
    
    // Check if user exists
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    // Delete user
    await user.destroy();
    
    res.status(200).json({
      status: 'success',
      message: 'Account deleted successfully'
    });
  } catch (error) {
    console.error('Delete account error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};

/**
 * @desc Verify a user account (admin only)
 * @route POST /api/users/:id/verify
 * @access Private (Admin)
 */
exports.verifyUser = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if user exists
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    // Update verification status
    user.isVerified = true;
    await user.save();
    
    res.status(200).json({
      status: 'success',
      message: 'User verified successfully',
      data: {
        user: {
          id: user.id,
          username: user.username,
          role: user.role,
          isVerified: user.isVerified
        }
      }
    });
  } catch (error) {
    console.error('Verify user error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
};
