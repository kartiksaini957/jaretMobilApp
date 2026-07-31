import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/owner_notes_data.dart';

/// Newest-first list of saved owner notes: date label + body, divided.
class OwnerNotesList extends StatelessWidget {
  const OwnerNotesList({super.key, required this.notes});

  final List<OwnerNote> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < notes.length; i++)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: i != notes.length - 1
                    ? const Border(
                        bottom: BorderSide(color: AppColors.glassBorderSoft),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notes[i].dateLabel, style: AppTextStyles.eyebrow),
                  const SizedBox(height: 6),
                  Text(
                    notes[i].body,
                    style: AppTextStyles.small.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
