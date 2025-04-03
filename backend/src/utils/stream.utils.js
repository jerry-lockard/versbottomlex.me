/**
 * Utility functions for handling streams and RTMP
 */

const crypto = require('crypto');

/**
 * Generate a secure stream key
 * @returns {string} A secure random stream key
 */
exports.generateStreamKey = () => {
  return crypto.randomBytes(20).toString('hex');
};

/**
 * Build the full RTMP URL for streaming
 * @param {string} streamKey The unique stream key
 * @returns {string} The full RTMP URL
 */
exports.buildRtmpUrl = (streamKey) => {
  const rtmpServer = process.env.RTMP_SERVER_URL || 'rtmp://localhost/live';
  return `${rtmpServer}/${streamKey}`;
};

/**
 * Build the HLS URL for viewers
 * @param {string} streamKey The unique stream key
 * @returns {string} The HLS URL for playback
 */
exports.buildHlsUrl = (streamKey) => {
  const hlsServer = process.env.HLS_SERVER_URL || 'http://localhost:8080/hls';
  return `${hlsServer}/${streamKey}.m3u8`;
};

/**
 * Calculate stream duration in seconds
 * @param {Date} startTime Stream start time
 * @param {Date} endTime Stream end time
 * @returns {number} Duration in seconds
 */
exports.calculateStreamDuration = (startTime, endTime) => {
  if (!startTime || !endTime) return 0;
  
  const start = new Date(startTime).getTime();
  const end = new Date(endTime).getTime();
  
  return Math.floor((end - start) / 1000);
};

/**
 * Check if a stream key is valid (exists and belongs to the user)
 * @param {string} streamKey The stream key to check
 * @param {UUID} userId The user ID
 * @param {Object} Stream The Stream model
 * @returns {Promise<boolean>} Whether the stream key is valid
 */
exports.isValidStreamKey = async (streamKey, userId, Stream) => {
  try {
    const stream = await Stream.findOne({
      where: {
        streamKey,
      },
    });
    
    if (!stream) return false;
    
    // Check if the stream belongs to the user
    return stream.performerId === userId;
  } catch (error) {
    console.error('Error validating stream key:', error);
    return false;
  }
};

/**
 * Format stream statistics for API response
 * @param {Object} stream The stream object
 * @returns {Object} Formatted stream statistics
 */
exports.formatStreamStats = (stream) => {
  const duration = exports.calculateStreamDuration(
    stream.actualStartTime,
    stream.endTime || new Date()
  );
  
  return {
    id: stream.id,
    title: stream.title,
    performerId: stream.performerId,
    status: stream.status,
    viewers: stream.viewerCount,
    duration, // in seconds
    startTime: stream.actualStartTime,
    endTime: stream.endTime,
  };
};