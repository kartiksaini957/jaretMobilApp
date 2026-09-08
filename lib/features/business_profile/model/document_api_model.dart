/// Model representing a document returned by `GET https://api.lightsignal.app/documents/`
class DocumentApiModel {
  final String documentId;
  final String filename;
  final String docType;
  final String extractionStatus;
  final bool ownerCorrected;
  final String uploadTimestamp;
  final String locationId;
  final bool outdated;

  DocumentApiModel({
    required this.documentId,
    required this.filename,
    required this.docType,
    required this.extractionStatus,
    required this.ownerCorrected,
    required this.uploadTimestamp,
    required this.locationId,
    required this.outdated,
  });

  factory DocumentApiModel.fromJson(Map<String, dynamic> json) {
    return DocumentApiModel(
      documentId: json['document_id'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      docType: json['doc_type'] as String? ?? '',
      extractionStatus: json['extraction_status'] as String? ?? '',
      ownerCorrected: json['owner_corrected'] as bool? ?? false,
      uploadTimestamp: json['upload_timestamp'] as String? ?? '',
      locationId: json['location_id'] as String? ?? '',
      outdated: json['outdated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'filename': filename,
      'doc_type': docType,
      'extraction_status': extractionStatus,
      'owner_corrected': ownerCorrected,
      'upload_timestamp': uploadTimestamp,
      'location_id': locationId,
      'outdated': outdated,
    };
  }

  /// Formatted category title in uppercase (e.g. "BUSINESS PROFILE", "LOGO IMAGE", "SERVICE AGREEMENT")
  String get formattedCategory {
    if (docType.isEmpty) return 'DOCUMENT';
    return docType.replaceAll('_', ' ').toUpperCase();
  }

  /// Formatted date string (e.g. "Jun 24, 2028")
  String get formattedDate {
    if (uploadTimestamp.isEmpty) return '';
    try {
      final parsed = DateTime.parse(uploadTimestamp);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final m = months[parsed.month - 1];
      final d = parsed.day.toString().padLeft(2, '0');
      final y = parsed.year;
      return '$m $d, $y';
    } catch (_) {
      return uploadTimestamp;
    }
  }

  /// Formatted extraction status (e.g. "Done", "Pending", "Processing")
  String get formattedStatus {
    if (extractionStatus.isEmpty) return 'Done';
    return extractionStatus[0].toUpperCase() +
        extractionStatus.substring(1).toLowerCase();
  }

  /// Whether the document is an image format
  bool get isImage {
    final lower = filename.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        docType.contains('image');
  }

  /// File extension
  String get fileExtension {
    if (!filename.contains('.')) return 'file';
    return filename.split('.').last.toLowerCase();
  }

  /// Parses a list of JSON items into a `List<DocumentApiModel>`
  static List<DocumentApiModel> fromJsonList(dynamic jsonList) {
    if (jsonList is! List) return [];
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map((item) => DocumentApiModel.fromJson(item))
        .toList();
  }
}
