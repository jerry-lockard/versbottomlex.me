const express = require('express');
const { body, param } = require('express-validator');
const streamController = require('../controllers/stream.controller');
const { verifyToken, checkRole, checkVerified, checkOwnership } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validation.middleware');

const router = express.Router();

/**
 * @swagger
 * /api/streams:
 *   get:
 *     summary: Get list of all public streams
 *     tags: [Streams]
 *     parameters:
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [scheduled, live, ended]
 *         description: Filter streams by status
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *         description: Maximum number of items to return
 *       - in: query
 *         name: offset
 *         schema:
 *           type: integer
 *           minimum: 0
 *         description: Number of items to skip
 *     responses:
 *       200:
 *         description: List of streams
 */
router.get('/', streamController.getAllStreams);

/**
 * @swagger
 * /api/streams/{id}:
 *   get:
 *     summary: Get stream by ID
 *     tags: [Streams]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *     responses:
 *       200:
 *         description: Stream data
 *       404:
 *         description: Stream not found
 */
router.get(
  '/:id',
  [
    param('id').isUUID().withMessage('Invalid stream ID'),
    validate,
  ],
  streamController.getStreamById
);

/**
 * @swagger
 * /api/streams:
 *   post:
 *     summary: Create a new stream
 *     tags: [Streams]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *             properties:
 *               title:
 *                 type: string
 *                 minLength: 3
 *                 maxLength: 100
 *               description:
 *                 type: string
 *               scheduledStartTime:
 *                 type: string
 *                 format: date-time
 *               isPrivate:
 *                 type: boolean
 *               privatePrice:
 *                 type: number
 *                 format: float
 *     responses:
 *       201:
 *         description: Stream created successfully
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized (must be performer)
 */
router.post(
  '/',
  [
    verifyToken,
    checkRole(['performer', 'admin']),
    checkVerified,
    body('title')
      .trim()
      .isLength({ min: 3, max: 100 })
      .withMessage('Title must be between 3 and 100 characters'),
    body('description')
      .optional()
      .trim(),
    body('scheduledStartTime')
      .optional()
      .isISO8601()
      .withMessage('Invalid date format'),
    body('isPrivate')
      .optional()
      .isBoolean()
      .withMessage('isPrivate must be a boolean'),
    body('privatePrice')
      .optional()
      .isFloat({ min: 0 })
      .withMessage('privatePrice must be a positive number'),
    validate,
  ],
  streamController.createStream
);

/**
 * @swagger
 * /api/streams/{id}:
 *   put:
 *     summary: Update a stream
 *     tags: [Streams]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 minLength: 3
 *                 maxLength: 100
 *               description:
 *                 type: string
 *               scheduledStartTime:
 *                 type: string
 *                 format: date-time
 *               isPrivate:
 *                 type: boolean
 *               privatePrice:
 *                 type: number
 *                 format: float
 *     responses:
 *       200:
 *         description: Stream updated successfully
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized (must be owner or admin)
 *       404:
 *         description: Stream not found
 */
router.put(
  '/:id',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid stream ID'),
    body('title')
      .optional()
      .trim()
      .isLength({ min: 3, max: 100 })
      .withMessage('Title must be between 3 and 100 characters'),
    body('description')
      .optional()
      .trim(),
    body('scheduledStartTime')
      .optional()
      .isISO8601()
      .withMessage('Invalid date format'),
    body('isPrivate')
      .optional()
      .isBoolean()
      .withMessage('isPrivate must be a boolean'),
    body('privatePrice')
      .optional()
      .isFloat({ min: 0 })
      .withMessage('privatePrice must be a positive number'),
    validate,
    checkOwnership('Stream', 'id'),
  ],
  streamController.updateStream
);

/**
 * @swagger
 * /api/streams/{id}/start:
 *   post:
 *     summary: Start a stream
 *     tags: [Streams]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *     responses:
 *       200:
 *         description: Stream started successfully
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized (must be owner or admin)
 *       404:
 *         description: Stream not found
 */
router.post(
  '/:id/start',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid stream ID'),
    validate,
    checkOwnership('Stream', 'id'),
  ],
  streamController.startStream
);

/**
 * @swagger
 * /api/streams/{id}/end:
 *   post:
 *     summary: End a stream
 *     tags: [Streams]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *     responses:
 *       200:
 *         description: Stream ended successfully
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized (must be owner or admin)
 *       404:
 *         description: Stream not found
 */
router.post(
  '/:id/end',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid stream ID'),
    validate,
    checkOwnership('Stream', 'id'),
  ],
  streamController.endStream
);

/**
 * @swagger
 * /api/streams/{id}/messages:
 *   get:
 *     summary: Get messages for a stream
 *     tags: [Streams]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *         description: Maximum number of items to return
 *       - in: query
 *         name: offset
 *         schema:
 *           type: integer
 *           minimum: 0
 *         description: Number of items to skip
 *     responses:
 *       200:
 *         description: List of messages
 *       404:
 *         description: Stream not found
 */
router.get(
  '/:id/messages',
  [
    param('id').isUUID().withMessage('Invalid stream ID'),
    validate,
  ],
  streamController.getStreamMessages
);

/**
 * @swagger
 * /api/streams/{id}/messages:
 *   post:
 *     summary: Send a message to a stream
 *     tags: [Streams]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Stream ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - content
 *             properties:
 *               content:
 *                 type: string
 *                 minLength: 1
 *     responses:
 *       201:
 *         description: Message sent successfully
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 *       404:
 *         description: Stream not found
 */
router.post(
  '/:id/messages',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid stream ID'),
    body('content')
      .trim()
      .notEmpty()
      .withMessage('Message content is required'),
    validate,
  ],
  streamController.sendMessage
);

module.exports = router;