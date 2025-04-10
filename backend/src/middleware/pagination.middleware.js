/**
 * Middleware to handle pagination for API endpoints
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
const paginate = (req, res, next) => {
  const page = parseInt(req.query.page, 10) || 1;
  const limit = parseInt(req.query.limit, 10) || 10;
  
  // Validate and sanitize inputs
  if (page < 1) {
    req.pagination = { page: 1, limit, offset: 0 };
  } else if (limit > 100) { 
    // Cap the maximum limit to prevent excessive data fetching
    req.pagination = { page, limit: 100, offset: (page - 1) * 100 };
  } else {
    req.pagination = { page, limit, offset: (page - 1) * limit };
  }
  
  // Add a helper method to format paginated responses
  res.paginate = (data, total) => {
    const { page, limit } = req.pagination;
    const lastPage = Math.ceil(total / limit);
    
    return {
      status: 'success',
      data,
      pagination: {
        total,
        per_page: limit,
        current_page: page,
        last_page: lastPage,
        from: (page - 1) * limit + 1,
        to: Math.min(page * limit, total),
        has_more_pages: page < lastPage
      }
    };
  };
  
  next();
};

module.exports = { paginate };