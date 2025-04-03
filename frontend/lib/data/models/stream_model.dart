import 'user_model.dart';

enum StreamStatus { scheduled, live, ended }

class Stream {
  final String id;
  final String title;
  final String? description;
  final StreamStatus status;
  final DateTime? scheduledStartTime;
  final DateTime? actualStartTime;
  final DateTime? endTime;
  final String? thumbnailUrl;
  final String streamKey;
  final String rtmpUrl;
  final bool isPrivate;
  final double? privatePrice;
  final int viewerCount;
  final String performerId;
  final User? performer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Stream({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.scheduledStartTime,
    this.actualStartTime,
    this.endTime,
    this.thumbnailUrl,
    required this.streamKey,
    required this.rtmpUrl,
    required this.isPrivate,
    this.privatePrice,
    required this.viewerCount,
    required this.performerId,
    this.performer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stream.fromJson(Map<String, dynamic> json) {
    return Stream(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: _parseStatus(json['status'] as String),
      scheduledStartTime: json['scheduledStartTime'] != null
          ? DateTime.parse(json['scheduledStartTime'] as String)
          : null,
      actualStartTime: json['actualStartTime'] != null
          ? DateTime.parse(json['actualStartTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      streamKey: json['streamKey'] as String,
      rtmpUrl: json['rtmpUrl'] as String,
      isPrivate: json['isPrivate'] as bool,
      privatePrice: json['privatePrice'] != null
          ? double.parse(json['privatePrice'].toString())
          : null,
      viewerCount: json['viewerCount'] as int,
      performerId: json['performerId'] as String,
      performer: json['performer'] != null
          ? User.fromJson(json['performer'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': _statusToString(status),
      'scheduledStartTime': scheduledStartTime?.toIso8601String(),
      'actualStartTime': actualStartTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
      'streamKey': streamKey,
      'rtmpUrl': rtmpUrl,
      'isPrivate': isPrivate,
      'privatePrice': privatePrice,
      'viewerCount': viewerCount,
      'performerId': performerId,
      'performer': performer?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static StreamStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return StreamStatus.scheduled;
      case 'live':
        return StreamStatus.live;
      case 'ended':
        return StreamStatus.ended;
      default:
        return StreamStatus.scheduled;
    }
  }

  static String _statusToString(StreamStatus status) {
    switch (status) {
      case StreamStatus.scheduled:
        return 'scheduled';
      case StreamStatus.live:
        return 'live';
      case StreamStatus.ended:
        return 'ended';
    }
  }

  bool get isLive => status == StreamStatus.live;
  bool get isScheduled => status == StreamStatus.scheduled;
  bool get isEnded => status == StreamStatus.ended;

  String get statusLabel {
    switch (status) {
      case StreamStatus.scheduled:
        return 'Scheduled';
      case StreamStatus.live:
        return 'Live';
      case StreamStatus.ended:
        return 'Ended';
    }
  }
}