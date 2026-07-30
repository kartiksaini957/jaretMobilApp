class ActionItemsResponse {
  final bool success;
  final List<ActionItem> data;

  ActionItemsResponse({required this.success, required this.data});

  factory ActionItemsResponse.fromJson(Map<String, dynamic> json) {
    return ActionItemsResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ActionItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class ActionItem {
  final String? id;
  final String label;
  final DateTime? dueDate;
  final String actionType;
  final String category;
  final String priority;
  final int daysUntilDue;
  final String? relatedEntity;

  ActionItem({
    this.id,
    required this.label,
    this.dueDate,
    required this.actionType,
    required this.category,
    required this.priority,
    required this.daysUntilDue,
    this.relatedEntity,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'],
      label: json['label'] ?? '',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      actionType: json['action_type'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      daysUntilDue: json['days_until_due'] ?? 0,
      relatedEntity: json['related_entity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'due_date': dueDate?.toIso8601String(),
      'action_type': actionType,
      'category': category,
      'priority': priority,
      'days_until_due': daysUntilDue,
      'related_entity': relatedEntity,
    };
  }
}
