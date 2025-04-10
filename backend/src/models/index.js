const { sequelize } = require('../config/database');
const User = require('./user.model');
const Stream = require('./stream.model');
const Payment = require('./payment.model');
const Message = require('./message.model');

// Define model relationships

// User - Stream relationship (Performer has many streams)
User.hasMany(Stream, { foreignKey: 'performerId', as: 'streams' });
Stream.belongsTo(User, { foreignKey: 'performerId', as: 'performer' });

// User - Payment relationships
User.hasMany(Payment, { foreignKey: 'userId', as: 'payments' });
Payment.belongsTo(User, { foreignKey: 'userId', as: 'user' });

User.hasMany(Payment, { foreignKey: 'performerId', as: 'earnings' });
Payment.belongsTo(User, { foreignKey: 'performerId', as: 'performer' });

// Stream - Payment relationship
Stream.hasMany(Payment, { foreignKey: 'streamId', as: 'payments' });
Payment.belongsTo(Stream, { foreignKey: 'streamId', as: 'stream' });

// User - Message relationship
User.hasMany(Message, { foreignKey: 'userId', as: 'messages' });
Message.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// Stream - Message relationship
Stream.hasMany(Message, { foreignKey: 'streamId', as: 'messages' });
Message.belongsTo(Stream, { foreignKey: 'streamId', as: 'stream' });

module.exports = {
  sequelize,
  User,
  Stream,
  Payment,
  Message,
};