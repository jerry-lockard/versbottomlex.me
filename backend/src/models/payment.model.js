const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Payment = sequelize.define(
  'Payment',
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },
    type: {
      type: DataTypes.ENUM('tip', 'private_show', 'subscription'),
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM('pending', 'completed', 'failed', 'refunded'),
      defaultValue: 'pending',
    },
    currency: {
      type: DataTypes.STRING(10),
      defaultValue: 'USD',
    },
    paymentMethod: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    paymentIntentId: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    transactionFee: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
    },
    // Refers to User model (who made the payment)
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    // Refers to User model (who received the payment)
    performerId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    // Optional reference to Stream model
    streamId: {
      type: DataTypes.UUID,
      allowNull: true,
    },
    metadata: {
      type: DataTypes.JSON,
      allowNull: true,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = Payment;