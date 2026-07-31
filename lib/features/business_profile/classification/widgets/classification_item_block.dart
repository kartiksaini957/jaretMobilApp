import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/classification_data.dart';
import 'confidence_badge.dart';

/// One classification item: eyebrow label + confidence badge, body text,
/// and the "Correct this" flow (button → text field → saved confirmation).
class ClassificationItemBlock extends StatelessWidget {
  const ClassificationItemBlock({
    super.key,
    required this.item,
    required this.isEditing,
    required this.isCorrected,
    required this.controller,
    required this.onCorrectThisTap,
    required this.onSave,
    required this.onCancel,
  });

  final ClassificationItem item;
  final bool isEditing;
  final bool isCorrected;
  final TextEditingController controller;
  final VoidCallback onCorrectThisTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
            ),
            ConfidenceBadge(confidence: item.confidence),
          ],
        ),
        const SizedBox(height: 6),
        Text(item.body, style: AppTextStyles.small.copyWith(height: 1.45)),
        const SizedBox(height: 10),
        if (isEditing) ...[
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            style: AppTextStyles.small.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              hintText: "Tell us what's actually true — plain words are "
                  'perfect.',
              hintStyle: AppTextStyles.small,
              filled: true,
              fillColor: AppColors.glassLight,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.ink,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save correction',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.glassBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
        ] else if (isCorrected)
          Text(
            '✓ Your correction is saved — it now overrides our read, and '
            'every agent uses it.',
            style: AppTextStyles.small.copyWith(
              color: AppColors.goodText,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          OutlinedButton(
            onPressed: onCorrectThisTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.glassBorder),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Correct this',
              style: AppTextStyles.buttonLabel.copyWith(fontSize: 12.5),
            ),
          ),
      ],
    );
  }
}
