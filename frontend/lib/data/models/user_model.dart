class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? displayName;
  final String? profilePicture;
  final String? bio;
  final bool isVerified;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.displayName,
    this.profilePicture,
    this.bio,
    required this.isVerified,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      isVerified: json['isVerified'] as bool,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'bio': bio,
      'isVerified': isVerified,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? displayName,
    String? profilePicture,
    String? bio,
    bool? isVerified,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      role: role,
      displayName: displayName ?? this.displayName,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isPerformer => role == 'performer';
  bool get isAdmin => role == 'admin';
  bool get isViewer => role == 'viewer';
  
  String get displayNameOrUsername => displayName ?? username;
}