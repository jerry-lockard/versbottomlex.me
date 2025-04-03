import 'user_model.dart';
import 'stream_model.dart';

enum PaymentType { tip, privateShow, subscription }
enum PaymentStatus { pending, completed, failed, refunded }

class Payment {
  final String id;
  final double amount;
  final PaymentType type;
  final PaymentStatus status;
  final String currency;
  final String paymentMethod;
  final String? paymentIntentId;
  final double? transactionFee;
  final String userId;
  final String performerId;
  final String? streamId;
  final Map<String, dynamic>? metadata;
  final User? user;
  final User? performer;
  final Stream? stream;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.currency,
    required this.paymentMethod,
    this.paymentIntentId,
    this.transactionFee,
    required this.userId,
    required this.performerId,
    this.streamId,
    this.metadata,
    this.user,
    this.performer,
    this.stream,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      amount: double.parse(json['amount'].toString()),
      type: _parseType(json['type'] as String),
      status: _parseStatus(json['status'] as String),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentIntentId: json['paymentIntentId'] as String?,
      transactionFee: json['transactionFee'] != null
          ? double.parse(json['transactionFee'].toString())
          : null,
      userId: json['userId'] as String,
      performerId: json['performerId'] as String,
      streamId: json['streamId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      performer: json['performer'] != null
          ? User.fromJson(json['performer'] as Map<String, dynamic>)
          : null,
      stream: json['stream'] != null
          ? Stream.fromJson(json['stream'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': _typeToString(type),
      'status': _statusToString(status),
      'currency': currency,
      'paymentMethod': paymentMethod,
      'paymentIntentId': paymentIntentId,
      'transactionFee': transactionFee,
      'userId': userId,
      'performerId': performerId,
      'streamId': streamId,
      'metadata': metadata,
      'user': user?.toJson(),
      'performer': performer?.toJson(),
      'stream': stream?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static PaymentType _parseType(String type) {
    switch (type) {
      case 'tip':
        return PaymentType.tip;
      case 'private_show':
        return PaymentType.privateShow;
      case 'subscription':
        return PaymentType.subscription;
      default:
        return PaymentType.tip;
    }
  }

  static String _typeToString(PaymentType type) {
    switch (type) {
      case PaymentType.tip:
        return 'tip';
      case PaymentType.privateShow:
        return 'private_show';
      case PaymentType.subscription:
        return 'subscription';
    }
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  static String _statusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  bool get isPending => status == PaymentStatus.pending;
  bool get isCompleted => status == PaymentStatus.completed;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isRefunded => status == PaymentStatus.refunded;

  String get typeLabel {
    switch (type) {
      case PaymentType.tip:
        return 'Tip';
      case PaymentType.privateShow:
        return 'Private Show';
      case PaymentType.subscription:
        return 'Subscription';
    }
  }

  String get statusLabel {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  String get amountDisplay => '\$${amount.toStringAsFixed(2)} $currency';
}