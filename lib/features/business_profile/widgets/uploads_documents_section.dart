import 'package:flutter/material.dart';

import '../theme/business_profile_colors.dart';

/// Section 17: Uploads & Documents. File picking isn't wired to a real
/// platform picker (no file_picker dependency) — the drop-zone and
/// "+ Add more" simulate adding files, and "Upload" always surfaces the
/// same error state shown in the reference design.
class UploadsDocumentsSection extends StatefulWidget {
  const UploadsDocumentsSection({super.key});

  @override
  State<UploadsDocumentsSection> createState() =>
      _UploadsDocumentsSectionState();
}

class _UploadsDocumentsSectionState extends State<UploadsDocumentsSection> {
  final List<({String name, String size})> _pending = [
    (name: 'ls_logo.png', size: '67.3 KB'),
    (name: 'appstore.png', size: '257.7 KB'),
  ];
  bool _showError = false;

  void _removeFile(String name) {
    setState(() {
      _pending.removeWhere((file) => file.name == name);
      _showError = false;
    });
  }

  void _addMore() {
    setState(() {
      final next = _pending.length + 1;
      _pending.add((name: 'document_$next.pdf', size: '120 KB'));
      _showError = false;
    });
  }

  void _upload() {
    if (_pending.isEmpty) return;
    setState(() => _showError = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload your leases, insurance policies, contracts, and '
          'licenses. LightSignal reads them automatically and fills in '
          'the key dates and details for you.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: BusinessProfileColors.mutedText,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BusinessProfileColors.fieldFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BusinessProfileColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.upload_outlined,
                    size: 16,
                    color: BusinessProfileColors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Documents',
                    style: TextStyle(
                      color: BusinessProfileColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'DOC TYPE HINT (OPTIONAL)',
                style: TextStyle(
                  color: BusinessProfileColors.faintText,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                style: const TextStyle(
                  color: BusinessProfileColors.white,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. lease, insurance, contract',
                  hintStyle: const TextStyle(
                    color: BusinessProfileColors.faintText,
                  ),
                  filled: true,
                  fillColor: BusinessProfileColors.fieldFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: BusinessProfileColors.fieldBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: BusinessProfileColors.fieldBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: BusinessProfileColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _DashedDropZone(onTap: _addMore),
              if (_pending.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'READY TO UPLOAD (${_pending.length})',
                  style: const TextStyle(
                    color: BusinessProfileColors.faintText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                for (final file in _pending) ...[
                  _PendingFileRow(
                    name: file.name,
                    size: file.size,
                    onRemove: () => _removeFile(file.name),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    TextButton(
                      onPressed: _addMore,
                      child: const Text(
                        '+ Add more',
                        style: TextStyle(
                          color: BusinessProfileColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: const Color(0xFF17BBA8),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: _upload,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.upload_outlined,
                                size: 14,
                                color: BusinessProfileColors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Upload ${_pending.length} files',
                                style: const TextStyle(
                                  color: BusinessProfileColors.white,
                                  fontSize: 12.5,
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
              if (_showError) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: BusinessProfileColors.errorFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: BusinessProfileColors.errorBorder,
                    ),
                  ),
                  child: Text(
                    "Couldn't upload: ${_pending.map((f) => f.name).join(', ')}",
                    style: const TextStyle(
                      color: BusinessProfileColors.errorBorder,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Row(
          children: [
            Text(
              'YOUR DOCUMENTS',
              style: TextStyle(
                color: BusinessProfileColors.faintText,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Spacer(),
            Icon(
              Icons.refresh,
              size: 18,
              color: BusinessProfileColors.faintText,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: BusinessProfileColors.fieldFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BusinessProfileColors.cardBorder),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.description_outlined,
                size: 40,
                color: BusinessProfileColors.faintText,
              ),
              SizedBox(height: 12),
              Text(
                'No documents yet',
                style: TextStyle(
                  color: BusinessProfileColors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Upload a lease, insurance policy, contract, or license '
                'above. LightSignal will read it and pull out the '
                'important dates, amounts, and terms automatically.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: BusinessProfileColors.faintText,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PendingFileRow extends StatelessWidget {
  const _PendingFileRow({
    required this.name,
    required this.size,
    required this.onRemove,
  });

  final String name;
  final String size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BusinessProfileColors.cardFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BusinessProfileColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 18,
            color: BusinessProfileColors.faintText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: BusinessProfileColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  size,
                  style: const TextStyle(
                    color: BusinessProfileColors.faintText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.visibility_outlined,
              size: 18,
              color: BusinessProfileColors.faintText,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.close,
              size: 18,
              color: BusinessProfileColors.faintText,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDropZone extends StatelessWidget {
  const _DashedDropZone({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 26),
          child: const Column(
            children: [
              Icon(
                Icons.file_upload_outlined,
                size: 26,
                color: BusinessProfileColors.white,
              ),
              SizedBox(height: 10),
              Text(
                'Drop files here or click to browse',
                style: TextStyle(
                  color: BusinessProfileColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'PDF · JPEG · PNG · Word (.docx) · .txt · .md · .xlsx · .csv',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: BusinessProfileColors.faintText,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashLength = 6.0;
      const gapLength = 5.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        dashPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    canvas.drawPath(
      dashPath,
      Paint()
        ..color = const Color(0x80FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
