import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/owner_notes_data.dart';

/// Newest-first list of saved owner notes: date label + body, divided.
/// Supports swipe/slide to delete.
class OwnerNotesList extends StatelessWidget {
  const OwnerNotesList({
    super.key,
    required this.notes,
    this.onDelete,
  });

  final List<OwnerNote> notes;
  final void Function(int index, OwnerNote note)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Center(
          child: Text(
            'No notes yet. Add your first note above.',
            style: AppTextStyles.small.copyWith(
              color: AppColors.mutedText,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < notes.length; i++)
            Dismissible(
              key: ValueKey(
                notes[i].id.isNotEmpty
                    ? notes[i].id
                    : '${notes[i].dateLabel}_${notes[i].body}_$i',
              ),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xFFD32F2F),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                onDelete?.call(i, notes[i]);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
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
            ),
        ],
      ),
    );
  }
}
