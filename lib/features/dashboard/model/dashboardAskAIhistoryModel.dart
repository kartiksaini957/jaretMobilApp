class ChatSummary {
  const ChatSummary({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    required this.lastMessage,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      messageCount: json['message_count'] as int? ?? 0,
      lastMessage: json['last_message'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String createdAt;
  final String updatedAt;
  final int messageCount;
  final String lastMessage;
}

class ChatListResponse {
  const ChatListResponse({required this.success, required this.data});

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ChatSummary.fromJson(e as Map<String, dynamic>))
        .toList();
    return ChatListResponse(success: json['success'] as bool? ?? false, data: list);
  }

  final bool success;
  final List<ChatSummary> data;
}

class ChatMessageDto {
  const ChatMessageDto({required this.role, required this.text, required this.ts});

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      role: json['role'] as String? ?? '',
      text: json['text'] as String? ?? '',
      ts: json['ts'] as String? ?? '',
    );
  }

  final String role; // "q" or "a"
  final String text;
  final String ts;
}

class ChatDetail {
  const ChatDetail({
    required this.id,
    required this.title,
    required this.surface,
    required this.createdAt,
    required this.messages,
  });

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ChatDetail(
      id: data['id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      surface: data['surface'] as String? ?? '',
      createdAt: data['created_at'] as String? ?? '',
      messages: (data['messages'] as List<dynamic>? ?? [])
          .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String title;
  final String surface;
  final String createdAt;
  final List<ChatMessageDto> messages;
}