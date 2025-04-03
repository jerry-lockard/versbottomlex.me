const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Stream = sequelize.define(
  'Stream',
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    title: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM('scheduled', 'live', 'ended'),
      defaultValue: 'scheduled',
    },
    scheduledStartTime: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    actualStartTime: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    endTime: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    thumbnailUrl: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    streamKey: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: true,
    },
    rtmpUrl: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    isPrivate: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    privatePrice: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
    },
    viewerCount: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    // Refers to User model
    performerId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = Stream;