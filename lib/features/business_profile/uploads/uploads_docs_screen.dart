import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api_services.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_nav_destinations.dart';
import '../../../widgets/app_nav_drawer.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/gradient_background.dart';
import '../flow/widgets/flow_header.dart';
import '../model/document_api_model.dart';
import '../model/document_review_model.dart';

/// Data model representing an uploaded document in Section 16
class UploadedDocumentItem {
  final String id;
  final String name;
  final String category;
  final String date;
  final String status;
  final String type;
  final bool isOutdated;
  final String? outdatedNote;
  final Map<String, String> extractedFields;
  final bool isAnnualRevenueEdited;

  UploadedDocumentItem({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.status,
    required this.type,
    this.isOutdated = false,
    this.outdatedNote,
    required this.extractedFields,
    this.isAnnualRevenueEdited = false,
  });

  UploadedDocumentItem copyWith({
    String? id,
    String? name,
    String? category,
    String? date,
    String? status,
    String? type,
    bool? isOutdated,
    String? outdatedNote,
    Map<String, String>? extractedFields,
    bool? isAnnualRevenueEdited,
  }) {
    return UploadedDocumentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      status: status ?? this.status,
      type: type ?? this.type,
      isOutdated: isOutdated ?? this.isOutdated,
      outdatedNote: outdatedNote ?? this.outdatedNote,
      extractedFields: extractedFields ?? Map.from(this.extractedFields),
      isAnnualRevenueEdited:
          isAnnualRevenueEdited ?? this.isAnnualRevenueEdited,
    );
  }
}

/// Section 16: "Upload your documents" UI Screen
class UploadsDocsScreen extends StatefulWidget {
  const UploadsDocsScreen({super.key});

  @override
  State<UploadsDocsScreen> createState() => _UploadsDocsScreenState();
}

class _UploadsDocsScreenState extends State<UploadsDocsScreen> {
  // Set of document IDs that are expanded
  final Set<String> _expandedDocIds = {};

  // Toggle for showing/hiding previous versions
  bool _showPreviousVersions = true;

  // Loading state while fetching documents list from API
  bool _isLoading = false;

  // Uploading state while uploading files to API
  bool _isUploading = false;

  // Files staged and ready to upload
  final List<PlatformFile> _stagedFiles = [];

  // Controller for optional Doc Type Hint
  final TextEditingController _docTypeHintController = TextEditingController();

  // Cached DocumentReviewModel per document ID
  final Map<String, DocumentReviewModel> _docReviewData = {};

  // Set of document IDs currently fetching review data
  final Set<String> _loadingReviewDocIds = {};

  // Set of document IDs currently downloading
  final Set<String> _downloadingDocIds = {};

  // Set of document IDs currently loading preview
  final Set<String> _previewingDocIds = {};

  // Error messages per document ID if review fetch fails
  final Map<String, String> _docReviewErrors = {};

  // Controllers for editing extracted fields per document id + field key
  final Map<String, TextEditingController> _controllers = {};

  // Active documents list
  List<UploadedDocumentItem> _documents = [];

  // Previous versions list
  List<UploadedDocumentItem> _previousVersions = [];

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  /// Fetches live documents from `GET https://api.lightsignal.app/documents/`
  Future<void> _fetchDocuments() async {
    setState(() => _isLoading = true);
    try {
      final List<DocumentApiModel> apiDocs = await ApiService().getDocuments();
      if (apiDocs.isNotEmpty && mounted) {
        final activeList = <UploadedDocumentItem>[];
        final prevList = <UploadedDocumentItem>[];

        for (final doc in apiDocs) {
          final item = UploadedDocumentItem(
            id: doc.documentId,
            name: doc.filename,
            category: doc.formattedCategory,
            date: doc.formattedDate,
            status: doc.formattedStatus,
            type: doc.fileExtension,
            isOutdated: doc.outdated,
            outdatedNote: doc.outdated
                ? 'This document has been superseded by a newer upload.'
                : null,
            isAnnualRevenueEdited: doc.ownerCorrected,
            extractedFields: {},
          );

          if (doc.outdated) {
            prevList.add(item);
          } else {
            activeList.add(item);
          }
        }

        setState(() {
          _documents = activeList;
          _previousVersions = prevList;
        });

        // Automatically fetch review for the first active document
        if (_documents.isNotEmpty) {
          final firstId = _documents.first.id;
          _toggleExpand(firstId);
        }
      }
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Error fetching documents: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Fetches review and extracted fields for a specific document on tap
  Future<void> _fetchDocumentReview(String docId) async {
    if (_loadingReviewDocIds.contains(docId)) return;

    setState(() {
      _loadingReviewDocIds.add(docId);
      _docReviewErrors.remove(docId);
    });

    try {
      final review = await ApiService().getDocumentReview(docId);
      if (mounted) {
        setState(() {
          _docReviewData[docId] = review;
          for (final f in review.fields) {
            final compositeKey = '${docId}_${f.key}';
            if (!_controllers.containsKey(compositeKey)) {
              _controllers[compositeKey] = TextEditingController(
                text: f.currentValue,
              );
            } else {
              _controllers[compositeKey]!.text = f.currentValue;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Error fetching document review: $e');
      if (mounted) {
        setState(() {
          _docReviewErrors[docId] = 'Failed to fetch';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingReviewDocIds.remove(docId);
        });
      }
    }
  }

  @override
  void dispose() {
    _docTypeHintController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(
    String docId,
    String fieldKey,
    String initialValue,
  ) {
    final compositeKey = '${docId}_$fieldKey';
    return _controllers.putIfAbsent(
      compositeKey,
      () => TextEditingController(text: initialValue),
    );
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.businessProfile,
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'docx',
          'txt',
          'md',
          'xlsx',
          'csv',
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          for (final file in result.files) {
            // Avoid duplicate additions
            if (!_stagedFiles.any(
              (f) => f.name == file.name && f.size == file.size,
            )) {
              _stagedFiles.add(file);
            }
          }
        });
      }
    } catch (e) {
      debugPrint('[UploadsDocsScreen] File picking error: $e');
    }
  }

  Future<void> _uploadStagedFiles() async {
    if (_stagedFiles.isEmpty) return;

    setState(() => _isUploading = true);
    if (mounted) {
      CustomToast.showSuccess(
        context,
        'Uploading ${_stagedFiles.length} document(s)...',
      );
    }

    try {
      final hint = _docTypeHintController.text.trim();
      await ApiService().uploadDocuments(
        files: List.from(_stagedFiles),
        docTypeHint: hint.isNotEmpty ? hint : null,
      );

      if (mounted) {
        setState(() {
          _stagedFiles.clear();
          _docTypeHintController.clear();
        });
        CustomToast.showSuccess(context, 'Document(s) uploaded successfully!');
      }
      await _fetchDocuments();
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Upload error: $e');
      if (mounted) {
        CustomToast.showSuccess(context, 'Upload error: $e');
      }
      await _fetchDocuments();
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _previewStagedFile(PlatformFile file) {
    final ext = file.extension?.toLowerCase() ?? '';
    final isImg =
        ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(10, 42, 60, 0.96),
                  Color.fromRGBO(6, 25, 38, 0.98),
                ],
              ),
              border: Border.all(
                color: const Color.fromRGBO(127, 227, 255, 0.45),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modal Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
                  child: Row(
                    children: [
                      Icon(
                        isImg
                            ? Icons.image_outlined
                            : Icons.description_outlined,
                        size: 20,
                        color: const Color(0xFF7FE3FF),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          file.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white70,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(127, 227, 255, 0.2),
                  height: 1,
                ),

                // Preview Body
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: isImg
                        ? (file.path != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InteractiveViewer(
                                    child: Image.file(
                                      File(file.path!),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : (file.bytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InteractiveViewer(
                                          child: Image.memory(
                                            file.bytes!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'Cannot preview this image',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      )))
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 64,
                                  color: Color(0xFF7FE3FF),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  file.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${(file.size / 1024).toStringAsFixed(1)} KB · ${ext.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Color(0xFF90DFFF),
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleExpand(String docId) {
    final willExpand = !_expandedDocIds.contains(docId);
    setState(() {
      if (willExpand) {
        _expandedDocIds.add(docId);
      } else {
        _expandedDocIds.remove(docId);
      }
    });

    if (willExpand && !_docReviewData.containsKey(docId)) {
      _fetchDocumentReview(docId);
    }
  }

  /// Shows confirmation dialog and deletes document via `DELETE /documents/{id}`
  Future<void> _confirmAndDeleteDocument(
    UploadedDocumentItem doc, {
    bool isPrevious = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F364C), Color(0xFF092434)],
              ),
              border: Border.all(
                color: const Color.fromRGBO(95, 224, 255, 0.45),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delete document?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"${doc.name}" will be permanently deleted. This cannot be undone.',
                  style: const TextStyle(
                    color: Color(0xFFD4EFFC),
                    fontSize: 13.5,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(dialogCtx).pop(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.08),
                            border: Border.all(
                              color: const Color.fromRGBO(127, 227, 255, 0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Delete Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(dialogCtx).pop(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE53935), Color(0xFFC62828)],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(229, 57, 53, 0.4),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !mounted) return;

    CustomToast.showSuccess(context, 'Deleting ${doc.name}...');
    try {
      await ApiService().deleteDocument(doc.id);
      if (mounted) {
        setState(() {
          if (isPrevious) {
            _previousVersions.removeWhere((d) => d.id == doc.id);
          } else {
            _documents.removeWhere((d) => d.id == doc.id);
          }
          _expandedDocIds.remove(doc.id);
          _docReviewData.remove(doc.id);
        });
        CustomToast.showSuccess(context, 'Document deleted successfully.');
      }
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Delete error: $e');
      if (mounted) {
        CustomToast.showSuccess(context, 'Delete failed: $e');
      }
    }
  }



  /// Downloads document bytes via `GET /documents/{id}/download?version=original`
  /// and saves it locally into device storage / Downloads directory
  Future<void> _downloadAndSaveDocument(UploadedDocumentItem doc) async {
    if (_downloadingDocIds.contains(doc.id)) return;

    setState(() => _downloadingDocIds.add(doc.id));
    CustomToast.showSuccess(context, 'Downloading ${doc.name}...');

    try {
      final bytes = await ApiService().downloadDocument(doc.id);

      Directory? targetDir;
      if (Platform.isAndroid) {
        final publicDownload = Directory('/storage/emulated/0/Download');
        if (await publicDownload.exists()) {
          targetDir = publicDownload;
        } else {
          targetDir = await getExternalStorageDirectory();
        }
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      targetDir ??= await getApplicationDocumentsDirectory();

      final cleanFilename = doc.name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final filePath = '${targetDir.path}/$cleanFilename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      debugPrint(
        '[UploadsDocsScreen] File successfully saved to: $filePath (${bytes.length} bytes)',
      );

      if (mounted) {
        CustomToast.showSuccess(context, 'Document saved to phone.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved: $cleanFilename'),
            backgroundColor: const Color(0xFF00BFA5),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Share / Open',
              textColor: Colors.white,
              onPressed: () {
                Share.shareXFiles([XFile(filePath)], text: doc.name);
              },
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Error downloading document: $e');
      if (mounted) {
        CustomToast.showSuccess(context, 'Download failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _downloadingDocIds.remove(doc.id));
      }
    }
  }

  bool _isImageFile(String type, List<int> bytes) {
    final lower = type.toLowerCase();
    if (lower == 'jpg' ||
        lower == 'jpeg' ||
        lower == 'png' ||
        lower == 'webp' ||
        lower == 'gif') {
      return true;
    }
    if (bytes.length >= 4) {
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) return true;
      if (bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        return true;
      }
      if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) return true;
    }
    return false;
  }

  String _extractReadableText(List<int> bytes) {
    try {
      final decoded = utf8.decode(bytes);
      if (decoded.contains('<') && decoded.contains('>')) {
        final clean = decoded
            .replaceAll(RegExp(r'<[^>]*>'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        if (clean.isNotEmpty) return clean;
      }
      return decoded;
    } catch (_) {
      final sb = StringBuffer();
      final currentWord = StringBuffer();
      for (final b in bytes) {
        if ((b >= 32 && b <= 126) || b == 10 || b == 13) {
          currentWord.writeCharCode(b);
        } else {
          if (currentWord.length > 3) {
            sb.writeln(currentWord.toString());
          }
          currentWord.clear();
        }
      }
      if (currentWord.length > 3) {
        sb.writeln(currentWord.toString());
      }
      final result = sb.toString().trim();
      return result.isNotEmpty ? result : 'Binary Document Preview';
    }
  }

  /// Hits `GET /documents/{id}/download?version=working` and shows live Document or Image Preview
  Future<void> _previewDocument(UploadedDocumentItem doc) async {
    if (_previewingDocIds.contains(doc.id)) return;

    setState(() => _previewingDocIds.add(doc.id));
    CustomToast.showSuccess(context, 'Loading preview for ${doc.name}...');

    try {
      List<int> bytes;
      try {
        bytes = await ApiService().downloadDocument(doc.id, version: 'working');
      } catch (_) {
        bytes = await ApiService().downloadDocument(
          doc.id,
          version: 'original',
        );
      }

      if (!mounted) return;

      final isImage = _isImageFile(doc.type, bytes);

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogCtx) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 650, maxWidth: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F324D), Color(0xFF061E2E)],
                ),
                border: Border.all(
                  color: const Color.fromRGBO(127, 227, 255, 0.45),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dialog Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                    child: Row(
                      children: [
                        Icon(
                          isImage
                              ? Icons.image_outlined
                              : Icons.description_outlined,
                          color: const Color(0xFF7FE3FF),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                isImage
                                    ? 'IMAGE PREVIEW'
                                    : 'DOCUMENT PREVIEW (WORKING VERSION)',
                                style: const TextStyle(
                                  color: Color(0xFF90DFFF),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromRGBO(127, 227, 255, 0.25),
                    height: 1,
                  ),

                  // Preview Content Body
                  Expanded(
                    child: isImage
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Center(
                                  child: Image.memory(
                                    Uint8List.fromList(bytes),
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => const Center(
                                          child: Text(
                                            'Could not render image preview.',
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F324D),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            doc.type.toUpperCase(),
                                            style: const TextStyle(
                                              color: Color(0xFF7FE3FF),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            doc.name,
                                            style: const TextStyle(
                                              color: Color(0xFF1E293B),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    const Divider(
                                      color: Color(0xFFE2E8F0),
                                      height: 1,
                                    ),
                                    const SizedBox(height: 14),
                                    if (_docReviewData.containsKey(doc.id)) ...[
                                      ..._docReviewData[doc.id]!.fields.map((
                                        f,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: Color(0xFF1E293B),
                                                fontSize: 13,
                                                height: 1.4,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '${f.displayName}: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: f.currentValue,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF334155),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ] else ...[
                                      SelectableText(
                                        _extractReadableText(bytes),
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontSize: 12.5,
                                          fontFamily: 'monospace',
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Bottom Action Buttons in Preview
                  const Divider(
                    color: Color.fromRGBO(127, 227, 255, 0.25),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(dialogCtx).pop();
                            _downloadAndSaveDocument(doc);
                          },
                          icon: const Icon(
                            Icons.download_outlined,
                            size: 17,
                            color: Color(0xFF7FE3FF),
                          ),
                          label: const Text(
                            'Save to phone',
                            style: TextStyle(
                              color: Color(0xFF7FE3FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          icon: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('[UploadsDocsScreen] Preview error: $e');
      if (mounted) {
        CustomToast.showSuccess(context, 'Failed to load preview: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _previewingDocIds.remove(doc.id));
      }
    }
  }

  void _saveExtractedFields(UploadedDocumentItem doc) {
    CustomToast.showSuccess(context, 'Changes saved successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 6,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              if (_isLoading)
                const LinearProgressIndicator(
                  minHeight: 2.5,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5FE0FF)),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlowHeader(
                        label: 'BUSINESS PROFILE · SECTION 16 · UPLOADS',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 14),
                      _buildDropzoneCard(),
                      const SizedBox(height: 24),
                      _buildYourDocumentsHeader(),
                      const SizedBox(height: 14),
                      _buildDocumentsList(),
                      const SizedBox(height: 20),
                      if (_previousVersions.isNotEmpty)
                        _buildPreviousVersionsSection(),
                      const SizedBox(height: 28),
                      _buildBottomButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Top Dropzone Upload Area
  // -------------------------------------------------------------
  Widget _buildDropzoneCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(95, 224, 255, 0.22),
            Color.fromRGBO(95, 224, 255, 0.07),
          ],
        ),
        border: Border.all(
          color: const Color.fromRGBO(127, 227, 255, 0.45),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 20, 40, 0.45),
            blurRadius: 32,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Add Documents
          const Row(
            children: [
              Icon(Icons.upload_outlined, size: 20, color: Color(0xFF7FE3FF)),
              SizedBox(width: 8),
              Text(
                'Add Documents',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // DOC TYPE HINT (OPTIONAL)
          const Text(
            'DOC TYPE HINT (OPTIONAL)',
            style: TextStyle(
              color: Color(0xFF90DFFF),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _docTypeHintController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'e.g. lease, insurance, contract',
              hintStyle: const TextStyle(
                color: Color.fromRGBO(207, 239, 251, 0.45),
                fontSize: 13,
              ),
              filled: true,
              fillColor: const Color.fromRGBO(6, 32, 48, 0.45),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(127, 227, 255, 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF5FE0FF),
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dashed Dropzone Area
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _isUploading ? null : _pickFiles,
              child: CustomPaint(
                painter: _DashedRectPainter(
                  color: const Color.fromRGBO(127, 227, 255, 0.5),
                  strokeWidth: 1.2,
                  gap: 5.0,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.file_upload_outlined,
                        size: 36,
                        color: Color(0xFF7FE3FF),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Drop files here or click to browse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'PDF · JPEG · PNG · Word (.docx) · .txt · .md · .xlsx · .csv',
                        style: TextStyle(
                          color: Color(0xFF90DFFF),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // READY TO UPLOAD SECTION
          if (_stagedFiles.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'READY TO UPLOAD (${_stagedFiles.length})',
              style: const TextStyle(
                color: Color(0xFF90DFFF),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stagedFiles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final file = _stagedFiles[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(6, 34, 50, 0.65),
                    border: Border.all(
                      color: const Color.fromRGBO(127, 227, 255, 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(127, 227, 255, 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: Color(0xFF7FE3FF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${(file.size / 1024).toStringAsFixed(1)} KB',
                              style: const TextStyle(
                                color: Color(0xFF90DFFF),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 19,
                          color: Color(0xFF90DFFF),
                        ),
                        tooltip: 'Preview',
                        onPressed: () => _previewStagedFile(file),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 19,
                          color: Color(0xFF90DFFF),
                        ),
                        tooltip: 'Remove',
                        onPressed: () {
                          setState(() {
                            _stagedFiles.removeAt(index);
                          });
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // + Add more button
                InkWell(
                  onTap: _isUploading ? null : _pickFiles,
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Text(
                      '+ Add more',
                      style: TextStyle(
                        color: Color(0xFF7FE3FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Upload file / Upload files button
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadStagedFiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1EC9B2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _isUploading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.upload_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                  label: Text(
                    _isUploading
                        ? 'Uploading...'
                        : (_stagedFiles.length == 1
                              ? 'Upload file'
                              : 'Upload files (${_stagedFiles.length})'),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // YOUR DOCUMENTS (X) Header
  // -------------------------------------------------------------
  Widget _buildYourDocumentsHeader() {
    return Row(
      children: [
        Text(
          'YOUR DOCUMENTS (${_documents.length})',
          style: AppTextStyles.eyebrow.copyWith(
            color: const Color(0xFFD4EFFC),
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.refresh_rounded,
            size: 20,
            color: Color(0xFF90DFFF),
          ),
          onPressed: _fetchDocuments,
          tooltip: 'Refresh',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),

        // InkWell(
        //   onTap: _clearAll,
        //   borderRadius: BorderRadius.circular(6),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        //     child: Row(
        //       children: [
        //         const Icon(
        //           Icons.delete_outline,
        //           size: 15,
        //           color: Color.fromRGBO(207, 239, 251, 0.75),
        //         ),
        //         const SizedBox(width: 4),
        //         Text(
        //           'Clear all',
        //           style: AppTextStyles.small.copyWith(
        //             color: const Color.fromRGBO(207, 239, 251, 0.75),
        //             fontSize: 12,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Active Documents List
  // -------------------------------------------------------------
  Widget _buildDocumentsList() {
    if (_documents.isEmpty && !_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(8, 36, 54, 0.5),
          border: Border.all(
            color: const Color.fromRGBO(127, 227, 255, 0.25),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'No active documents. Upload above to extract business fields.',
            style: TextStyle(color: Color(0xFFD4EFFC), fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: _documents.map((doc) => _buildDocumentCard(doc)).toList(),
    );
  }

  // -------------------------------------------------------------
  // Single Document Card (Collapsed / Expanded)
  // -------------------------------------------------------------
  Widget _buildDocumentCard(
    UploadedDocumentItem doc, {
    bool isPrevious = false,
  }) {
    final isExpanded = _expandedDocIds.contains(doc.id);
    final isImage =
        doc.type == 'jpg' || doc.type == 'png' || doc.type == 'jpeg';
    final isFailed =
        doc.status.toLowerCase() == 'failed' ||
        doc.status.toLowerCase().contains('fail') ||
        doc.status.toLowerCase().contains("couldn't");
    final hasReviewData = _docReviewData.containsKey(doc.id);
    final isReviewLoading = _loadingReviewDocIds.contains(doc.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFailed
              ? [
                  const Color.fromRGBO(60, 20, 25, 0.6),
                  const Color.fromRGBO(40, 15, 20, 0.6),
                ]
              : (isPrevious
                    ? [
                        const Color.fromRGBO(8, 38, 56, 0.7),
                        const Color.fromRGBO(6, 28, 42, 0.7),
                      ]
                    : [
                        const Color.fromRGBO(95, 224, 255, 0.18),
                        const Color.fromRGBO(95, 224, 255, 0.06),
                      ]),
        ),
        border: Border.all(
          color: isFailed
              ? const Color.fromRGBO(255, 120, 120, 0.45)
              : (isPrevious
                    ? const Color.fromRGBO(127, 227, 255, 0.25)
                    : const Color.fromRGBO(127, 227, 255, 0.42)),
          width: 1.1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 20, 40, 0.35),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Row
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isFailed ? null : () => _toggleExpand(doc.id),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  // File Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isFailed
                          ? const Color.fromRGBO(255, 100, 100, 0.15)
                          : const Color.fromRGBO(127, 227, 255, 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isFailed
                            ? const Color.fromRGBO(255, 120, 120, 0.4)
                            : const Color.fromRGBO(127, 227, 255, 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isImage
                          ? Icons.image_outlined
                          : Icons.description_outlined,
                      size: 20,
                      color: isFailed
                          ? const Color(0xFFFF9E9E)
                          : const Color(0xFF7FE3FF),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // File Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (doc.category.isNotEmpty)
                              Text(
                                doc.category,
                                style: const TextStyle(
                                  color: Color(0xFF90DFFF),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            Text(
                              doc.date,
                              style: const TextStyle(
                                color: Color.fromRGBO(207, 239, 251, 0.7),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isFailed)
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Color(0xFFFF7A7A),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "Couldn't read",
                                    style: TextStyle(
                                      color: Color(0xFFFF7A7A),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    size: 12,
                                    color: Color(0xFF26C281),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    doc.status,
                                    style: const TextStyle(
                                      color: Color(0xFF26C281),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (doc.isOutdated) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 180, 50, 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color.fromRGBO(255, 180, 50, 0.4),
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              'outdated',
                              style: TextStyle(
                                color: Color(0xFFFFD466),
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Action Icon Buttons Row (Compact and responsive)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isFailed) ...[
                        _buildCompactActionButton(
                          icon: _downloadingDocIds.contains(doc.id)
                              ? Icons.hourglass_top_outlined
                              : Icons.download_outlined,
                          tooltip: 'Download',
                          onTap: () => _downloadAndSaveDocument(doc),
                        ),
                        const SizedBox(width: 2),
                        _buildCompactActionButton(
                          icon: _previewingDocIds.contains(doc.id)
                              ? Icons.hourglass_top_outlined
                              : Icons.article_outlined,
                          tooltip: 'Preview Document',
                          onTap: () => _previewDocument(doc),
                        ),
                        const SizedBox(width: 2),
                      ],
                      _buildCompactActionButton(
                        icon: Icons.delete_outline,
                        tooltip: 'Delete',
                        onTap: () => _confirmAndDeleteDocument(
                          doc,
                          isPrevious: isPrevious,
                        ),
                      ),
                      if (!isFailed) ...[
                        const SizedBox(width: 2),
                        _buildCompactActionButton(
                          icon: isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          tooltip: isExpanded ? 'Collapse' : 'Expand',
                          iconSize: 21,
                          onTap: () => _toggleExpand(doc.id),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Failed / Couldn't read warning banner
          if (isFailed)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(255, 80, 80, 0.12),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 100, 100, 0.35),
                    width: 1,
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✕ ',
                      style: TextStyle(
                        color: Color(0xFFFF7A7A),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "We couldn't read this document. Try uploading a clearer copy, or fill in the key details manually in your Business Profile.",
                        style: TextStyle(
                          color: Color(0xFFFF9E9E),
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Note if outdated in previous versions
          if (doc.isOutdated && doc.outdatedNote != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                doc.outdatedNote!,
                style: const TextStyle(
                  color: Color.fromRGBO(207, 239, 251, 0.7),
                  fontSize: 11.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Expanded Content Area with Dynamic Extracted Fields
          if (isExpanded && !isFailed) ...[
            const Divider(
              color: Color.fromRGBO(127, 227, 255, 0.25),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXTRACTED FIELDS — EDIT ANY VALUE, THEN SAVE',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: const Color(0xFF90DFFF),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (isReviewLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF5FE0FF),
                        ),
                      ),
                    )
                  else if (hasReviewData)
                    ..._docReviewData[doc.id]!.fields.map((f) {
                      return _buildReviewFieldRow(docId: doc.id, field: f);
                    })
                  else if (doc.extractedFields.isNotEmpty)
                    ...doc.extractedFields.entries.map((entry) {
                      final isRevenueField = entry.key == 'Annual Revenue';
                      return _buildExtractedFieldRow(
                        docId: doc.id,
                        fieldKey: entry.key,
                        fieldValue: entry.value,
                        isEdited: isRevenueField && doc.isAnnualRevenueEdited,
                      );
                    })
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No extracted fields found for this document.',
                        style: TextStyle(
                          color: Color.fromRGBO(207, 239, 251, 0.7),
                          fontSize: 12.5,
                        ),
                      ),
                    ),

                  const SizedBox(height: 14),
                  // Card Bottom Actions (Status + Save changes)
                  Row(
                    children: [
                      if (_docReviewErrors.containsKey(doc.id))
                        InkWell(
                          onTap: () => _fetchDocumentReview(doc.id),
                          child: Text(
                            _docReviewErrors[doc.id]!,
                            style: const TextStyle(
                              color: Color(0xFFFF7A7A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      else if (_docReviewData.containsKey(doc.id))
                        const Text(
                          'Review loaded',
                          style: TextStyle(
                            color: Color(0xFF26C281),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _saveExtractedFields(doc),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                              ),
                              border: Border.all(
                                color: const Color.fromRGBO(255, 255, 255, 0.3),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 150, 130, 0.4),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Save changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    double iconSize = 17,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Icon(icon, size: iconSize, color: const Color(0xFFD4EFFC)),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Live Review Extracted Field Input Box
  // -------------------------------------------------------------
  Widget _buildReviewFieldRow({
    required String docId,
    required ExtractedFieldModel field,
  }) {
    final controller = _getController(docId, field.key, field.currentValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field.displayName,
                style: const TextStyle(
                  color: Color(0xFFD4EFFC),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (field.edited) ...[
                const SizedBox(width: 6),
                const Text(
                  '• edited',
                  style: TextStyle(
                    color: Color(0xFF5FE0FF),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color.fromRGBO(6, 32, 48, 0.45),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(127, 227, 255, 0.35),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF5FE0FF),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Fallback Extracted Field Input Box
  // -------------------------------------------------------------
  Widget _buildExtractedFieldRow({
    required String docId,
    required String fieldKey,
    required String fieldValue,
    bool isEdited = false,
  }) {
    final controller = _getController(docId, fieldKey, fieldValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                fieldKey,
                style: const TextStyle(
                  color: Color(0xFFD4EFFC),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isEdited) ...[
                const SizedBox(width: 6),
                const Text(
                  '• edited',
                  style: TextStyle(
                    color: Color(0xFF5FE0FF),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color.fromRGBO(6, 32, 48, 0.45),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(127, 227, 255, 0.35),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF5FE0FF),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // PREVIOUS VERSIONS (1) Section
  // -------------------------------------------------------------
  Widget _buildPreviousVersionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () =>
              setState(() => _showPreviousVersions = !_showPreviousVersions),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  _showPreviousVersions
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: const Color(0xFF90DFFF),
                ),
                const SizedBox(width: 6),
                Text(
                  'PREVIOUS VERSIONS (${_previousVersions.length})',
                  style: AppTextStyles.eyebrow.copyWith(
                    color: const Color(0xFF90DFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_showPreviousVersions)
          ..._previousVersions.map(
            (doc) => _buildDocumentCard(doc, isPrevious: true),
          ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Bottom Buttons: Skip & Complete Profile
  // -------------------------------------------------------------
  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color.fromRGBO(6, 32, 48, 0.45),
                border: Border.all(
                  color: const Color.fromRGBO(127, 227, 255, 0.35),
                  width: 1.1,
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        // Complete Profile Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              CustomToast.showSuccess(
                context,
                'Business profile completed successfully.',
              );
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                ),
                border: Border.all(
                  color: const Color.fromRGBO(127, 227, 255, 0.7),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(14, 165, 233, 0.4),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Complete profile →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for rounded dashed border around the file dropzone.
class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  final Color color;
  final double strokeWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(14),
        ),
      );

    final Path dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? gap * 1.5 : gap;
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}
