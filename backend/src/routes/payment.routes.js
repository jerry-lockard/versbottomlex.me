const express = require('express');
const { body, param } = require('express-validator');
const paymentController = require('../controllers/payment.controller');
const { verifyToken, checkVerified } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validation.middleware');

const router = express.Router();

/**
 * @swagger
 * /api/payments/tip:
 *   post:
 *     summary: Send a tip to a performer
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - performerId
 *               - amount
 *               - paymentMethod
 *             properties:
 *               performerId:
 *                 type: string
 *                 format: uuid
 *               streamId:
 *                 type: string
 *                 format: uuid
 *               amount:
 *                 type: number
 *                 format: float
 *                 minimum: 1
 *               paymentMethod:
 *                 type: string
 *                 enum: [stripe, crypto]
 *     responses:
 *       201:
 *         description: Tip payment created
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Account not verified
 */
router.post(
  '/tip',
  [
    verifyToken,
    checkVerified,
    body('performerId')
      .isUUID()
      .withMessage('Invalid performer ID'),
    body('streamId')
      .optional()
      .isUUID()
      .withMessage('Invalid stream ID'),
    body('amount')
      .isFloat({ min: 1 })
      .withMessage('Amount must be at least 1'),
    body('paymentMethod')
      .isIn(['stripe', 'crypto'])
      .withMessage('Payment method must be stripe or crypto'),
    validate,
  ],
  paymentController.createTip
);

/**
 * @swagger
 * /api/payments/private-show:
 *   post:
 *     summary: Purchase access to a private show
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - streamId
 *               - paymentMethod
 *             properties:
 *               streamId:
 *                 type: string
 *                 format: uuid
 *               paymentMethod:
 *                 type: string
 *                 enum: [stripe, crypto]
 *     responses:
 *       201:
 *         description: Private show purchase created
 *       400:
 *         description: Invalid input
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Account not verified
 *       404:
 *         description: Stream not found
 */
router.post(
  '/private-show',
  [
    verifyToken,
    checkVerified,
    body('streamId')
      .isUUID()
      .withMessage('Invalid stream ID'),
    body('paymentMethod')
      .isIn(['stripe', 'crypto'])
      .withMessage('Payment method must be stripe or crypto'),
    validate,
  ],
  paymentController.purchasePrivateShow
);

/**
 * @swagger
 * /api/payments/history:
 *   get:
 *     summary: Get payment history for current user
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [tip, private_show, subscription]
 *         description: Filter by payment type
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
 *         description: Payment history
 *       401:
 *         description: Not authenticated
 */
router.get(
  '/history',
  [
    verifyToken,
  ],
  paymentController.getPaymentHistory
);

/**
 * @swagger
 * /api/payments/earnings:
 *   get:
 *     summary: Get earnings for current performer
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [tip, private_show, subscription]
 *         description: Filter by payment type
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
 *         description: Earnings history
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not a performer
 */
router.get(
  '/earnings',
  [
    verifyToken,
  ],
  paymentController.getEarnings
);

/**
 * @swagger
 * /api/payments/{id}:
 *   get:
 *     summary: Get payment details
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Payment ID
 *     responses:
 *       200:
 *         description: Payment details
 *       401:
 *         description: Not authenticated
 *       403:
 *         description: Not authorized to view this payment
 *       404:
 *         description: Payment not found
 */
router.get(
  '/:id',
  [
    verifyToken,
    param('id').isUUID().withMessage('Invalid payment ID'),
    validate,
  ],
  paymentController.getPaymentById
);

module.exports = router;