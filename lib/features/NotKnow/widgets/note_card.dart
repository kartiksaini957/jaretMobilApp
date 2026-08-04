import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Glass card used for the "A business near you" style insight preview
/// and other eyebrow-labelled callouts.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.eyebrow,
    required this.body,
    this.footer,
  });

  final String eyebrow;
  final InlineSpan body;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow, style: AppTextStyles.eyebrow.copyWith(fontSize: 10.5)),
          const SizedBox(height: 8),
          Text.rich(
            body,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(
              footer!,
              style: AppTextStyles.small.copyWith(
                color: AppColors.faintText,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
