class TeamMemberDto {
  const TeamMemberDto({
    required this.id,
    required this.ownerUserId,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory TeamMemberDto.fromJson(Map<String, dynamic> json) {
    return TeamMemberDto(
      id: json['id'] as String? ?? '',
      ownerUserId: json['owner_user_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final String id;
  final String ownerUserId;
  final String email;
  final String role;
  final String status; // "invited", "active", etc.
  final String createdAt;
}

class TeamListResponse {
  const TeamListResponse({required this.success, required this.data});

  factory TeamListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => TeamMemberDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return TeamListResponse(success: json['success'] as bool? ?? false, data: list);
  }

  final bool success;
  final List<TeamMemberDto> data;
}

class ShareLinkDto {
  const ShareLinkDto({
    required this.id,
    required this.userId,
    required this.scope,
    required this.readOnly,
    required this.expiresAt,
    required this.createdAt,
  });

  factory ShareLinkDto.fromJson(Map<String, dynamic> json) {
    return ShareLinkDto(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
      readOnly: json['read_only'] as bool? ?? true,
      expiresAt: json['expires_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final String id;
  final String userId;
  final String scope;
  final bool readOnly;
  final String expiresAt;
  final String createdAt;

  /// Postman only returns the share-link `id`, not a full URL. Adjust this
  /// base if the backend uses a different public share domain/path.
  String get shareUrl => 'https://app.lightsignal.app/shared/$id';
}

class SessionItemDto {
  const SessionItemDto({
    required this.sessionId,
    required this.device,
    required this.ipAddress,
    required this.lastActive,
    required this.isCurrent,
  });

  factory SessionItemDto.fromJson(Map<String, dynamic> json) {
    return SessionItemDto(
      sessionId: json['session_id'] as String? ?? '',
      device: json['device'] as String? ?? 'Unknown device',
      ipAddress: json['ip_address'] as String? ?? '',
      lastActive: json['last_active'] as String? ?? '',
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  final String sessionId;
  final String device;
  final String ipAddress;
  final String lastActive;
  final bool isCurrent;
}

class SessionsListResponse {
  const SessionsListResponse({required this.success, required this.data});

  factory SessionsListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => SessionItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return SessionsListResponse(
      success: json['success'] as bool? ?? false,
      data: list,
    );
  }

  final bool success;
  final List<SessionItemDto> data;
}