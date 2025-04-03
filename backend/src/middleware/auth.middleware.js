const jwt = require('jsonwebtoken');
const { User } = require('../models');
const jwtConfig = require('../config/jwt');

/**
 * Middleware to verify JWT token and set user in request
 */
exports.verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        status: 'error', 
        message: 'No token provided' 
      });
    }

    const token = authHeader.split(' ')[1];
    
    const decoded = jwt.verify(token, jwtConfig.secret);
    
    const user = await User.findByPk(decoded.id);
    
    if (!user) {
      return res.status(401).json({ 
        status: 'error', 
        message: 'User not found' 
      });
    }
    
    // Check token version (for invalidating tokens when password changes)
    if (user.tokenVersion !== decoded.tokenVersion) {
      return res.status(401).json({ 
        status: 'error', 
        message: 'Token is invalid, please login again' 
      });
    }
    
    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ 
        status: 'error', 
        message: 'Token expired' 
      });
    }
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ 
        status: 'error', 
        message: 'Invalid token' 
      });
    }
    
    return res.status(500).json({ 
      status: 'error', 
      message: 'Internal server error', 
      error: error.message 
    });
  }
};

/**
 * Middleware to check if user has required role
 */
exports.checkRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ 
        status: 'error', 
        message: 'Unauthorized' 
      });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ 
        status: 'error', 
        message: 'Access denied' 
      });
    }
    
    next();
  };
};

/**
 * Middleware to check if user is verified
 */
exports.checkVerified = (req, res, next) => {
  if (!req.user.isVerified) {
    return res.status(403).json({ 
      status: 'error', 
      message: 'Account not verified' 
    });
  }
  
  next();
};

/**
 * Middleware to check if user owns the resource
 */
exports.checkOwnership = (resource, idParam) => {
  return async (req, res, next) => {
    try {
      const resourceId = req.params[idParam];
      
      if (!resourceId) {
        return res.status(400).json({ 
          status: 'error', 
          message: 'Resource ID not provided' 
        });
      }
      
      const model = require(`../models`)[resource];
      const resourceInstance = await model.findByPk(resourceId);
      
      if (!resourceInstance) {
        return res.status(404).json({ 
          status: 'error', 
          message: `${resource} not found` 
        });
      }
      
      // Allow admins to access any resource
      if (req.user.role === 'admin') {
        return next();
      }
      
      // Check if user is the owner
      if (resource === 'Stream' && resourceInstance.performerId !== req.user.id) {
        return res.status(403).json({ 
          status: 'error', 
          message: 'Access denied' 
        });
      }
      
      // For other resources that have userId
      if (resourceInstance.userId && resourceInstance.userId !== req.user.id) {
        return res.status(403).json({ 
          status: 'error', 
          message: 'Access denied' 
        });
      }
      
      req.resource = resourceInstance;
      next();
    } catch (error) {
      return res.status(500).json({ 
        status: 'error', 
        message: 'Internal server error', 
        error: error.message 
      });
    }
  };
};
