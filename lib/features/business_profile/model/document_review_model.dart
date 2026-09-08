/// Model representing single extracted field in document review
class ExtractedFieldModel {
  final String key;
  final String displayName;
  final String currentValue;
  final bool edited;

  ExtractedFieldModel({
    required this.key,
    required this.displayName,
    required this.currentValue,
    this.edited = false,
  });

  factory ExtractedFieldModel.fromJson(Map<String, dynamic> json) {
    return ExtractedFieldModel(
      key: json['key'] as String? ?? '',
      displayName:
          json['display_name'] as String? ?? (json['key'] as String? ?? ''),
      currentValue: json['current_value']?.toString() ?? '',
      edited: json['edited'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'display_name': displayName,
      'current_value': currentValue,
      'edited': edited,
    };
  }

  ExtractedFieldModel copyWith({
    String? key,
    String? displayName,
    String? currentValue,
    bool? edited,
  }) {
    return ExtractedFieldModel(
      key: key ?? this.key,
      displayName: displayName ?? this.displayName,
      currentValue: currentValue ?? this.currentValue,
      edited: edited ?? this.edited,
    );
  }
}

/// Model representing `GET https://api.lightsignal.app/documents/{document_id}/review` response
class DocumentReviewModel {
  final String documentId;
  final String docType;
  final String extractionStatus;
  final bool ownerCorrected;
  final List<ExtractedFieldModel> fields;

  DocumentReviewModel({
    required this.documentId,
    required this.docType,
    required this.extractionStatus,
    required this.ownerCorrected,
    required this.fields,
  });

  factory DocumentReviewModel.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    final parsedFields = <ExtractedFieldModel>[];
    if (rawFields is List) {
      for (final item in rawFields) {
        if (item is Map<String, dynamic>) {
          parsedFields.add(ExtractedFieldModel.fromJson(item));
        }
      }
    }

    return DocumentReviewModel(
      documentId: json['document_id'] as String? ?? '',
      docType: json['doc_type'] as String? ?? '',
      extractionStatus: json['extraction_status'] as String? ?? '',
      ownerCorrected: json['owner_corrected'] as bool? ?? false,
      fields: parsedFields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'doc_type': docType,
      'extraction_status': extractionStatus,
      'owner_corrected': ownerCorrected,
      'fields': fields.map((f) => f.toJson()).toList(),
    };
  }
}
