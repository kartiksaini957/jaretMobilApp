class NotificationTestResponse {
  const NotificationTestResponse({
    required this.success,
    required this.message,
    required this.sentAt,
  });

  factory NotificationTestResponse.fromJson(Map<String, dynamic> json) {
    return NotificationTestResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      sentAt: json['sent_at'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
  final String sentAt;
}