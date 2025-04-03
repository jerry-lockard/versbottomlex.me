import 'user_model.dart';

class Message {
  final String id;
  final String content;
  final bool isDeleted;
  final String userId;
  final String streamId;
  final User? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.content,
    required this.isDeleted,
    required this.userId,
    required this.streamId,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      isDeleted: json['isDeleted'] as bool,
      userId: json['userId'] as String,
      streamId: json['streamId'] as String,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isDeleted': isDeleted,
      'userId': userId,
      'streamId': streamId,
      'user': user?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a message from socket event data
  factory Message.fromSocketEvent(Map<String, dynamic> data) {
    return Message(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: data['message'] as String,
      isDeleted: false,
      userId: data['userId'] as String,
      streamId: data['streamId'] as String,
      user: null, // Socket events typically don't include full user data
      createdAt: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'] as String)
          : DateTime.now(),
      updatedAt: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'] as String)
          : DateTime.now(),
    );
  }
}