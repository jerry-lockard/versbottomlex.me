const express = require('express');
const { body, param } = require('express-validator');
const userController = require('../controllers/user.controller');
const { verifyToken, checkRole } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validation.middleware');

const router = express.Router();

/**
 * @swagger
 * /api/users/{id}:
 *   get:
 *     summary: Get user profile by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: User profile data
 *       404:
 *         description: User not found
 */
router.get(
  '/:id',
  [
    param('id').isUUID().withMessage('Invalid user ID'),
    validate,
  ],
  userController.getUserById
);

/**
 * @swagger
 * /api/users/{id}/streams:
 *   get:
 *     summary: Get streams by user ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
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
 *       404:
 *         description: User not found
 */
router.get(
  '/:id/streams',
  [
    param('id').isUUID().withMessage('Invalid user ID'),
    validate,
  ],
  userController.getUserStreams
);

/**
 * @swagger
 * /api/users/profile:
 *   put:
 *     summary: Update user profile
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               displayName:
 *                 type: string
 *                 maxLength: 50
 *               bio:
 *                 type: string
 *               profilePicture:
 *                 type: string
 *                 format: uri
 *     responses:
 *       200:
 *         description: Profile updated successfully
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 */
router.put(
  '/profile',
  [
    verifyToken,
    body('displayName')
      .optional()
      .trim()
      .isLength({ max: 50 })
      .withMessage('Display name cannot exceed 50 characters'),
    body('bio')
      .optional()
      .trim(),
    body('profilePicture')
      .optional()
      .trim()
      .isURL()
      .withMessage('Profile picture must be a valid URL'),
    validate,
  ],
  userController.updateProfile
);

/**
 * @swagger
 * /api/users/{id}:
 *   delete:
 *     summary: Delete user account
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: Account deleted successfully
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized to delete this account
 *       404:
 *         description: User not found
 */
router.delete(
  '/:id',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid user ID'),
    validate,
  ],
  userController.deleteAccount
);

/**
 * @swagger
 * /api/users/{id}/verify:
 *   post:
 *     summary: Verify a user account (admin only)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: Account verified successfully
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized (admin only)
 *       404:
 *         description: User not found
 */
router.post(
  '/:id/verify',
  [
    verifyToken,
    checkRole(['admin']),
    param('id').isUUID().withMessage('Invalid user ID'),
    validate,
  ],
  userController.verifyUser
);

module.exports = router;