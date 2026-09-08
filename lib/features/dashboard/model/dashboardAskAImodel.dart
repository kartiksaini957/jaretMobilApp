class DashboardAskResponse {
  const DashboardAskResponse({required this.success, required this.data});

  factory DashboardAskResponse.fromJson(Map<String, dynamic> json) {
    return DashboardAskResponse(
      success: json['success'] as bool? ?? false,
      data: DashboardAskData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final DashboardAskData data;
}

class DashboardAskData {
  const DashboardAskData({
    required this.chatId,
    required this.title,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  factory DashboardAskData.fromJson(Map<String, dynamic> json) {
    return DashboardAskData(
      chatId: json['chat_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final String chatId;
  final String title;
  final String question;
  final String answer;
  final String createdAt;
}