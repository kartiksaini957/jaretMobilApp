import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// "Tell LightSignal what you're noticing" card: description + a free-text
/// note field + "Save note →".
class OwnerNoteInputCard extends StatelessWidget {
  const OwnerNoteInputCard({
    super.key,
    required this.controller,
    required this.onSave,
  });

  final TextEditingController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tell LightSignal what you're noticing",
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            'Wins, problems, plans, context — plain words. You bring the '
            'human signal; we bring the math. Every note flows to every '
            'agent on its next read, so "Friday dough sells out by 8" '
            'changes what the forecasts and health reads conclude.',
            style: AppTextStyles.small,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            style: AppTextStyles.small.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              hintText:
                  "e.g. Valentine's Day lands on a Saturday this year — "
                  'expecting the biggest night of the quarter.',
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
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.ink,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Save note →',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
