import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
class ReminderData {
  const ReminderData({
    required this.dotColor,
    required this.title,
    this.subtitle,
    this.subtitleColor,
  });

  final Color dotColor;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
}

class RemindersCard extends StatelessWidget {
  const RemindersCard({super.key, required this.reminders});
  final List<ReminderData> reminders;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 10,
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < reminders.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _ReminderTile(reminder: reminders[i]),
          ],
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});
  final ReminderData reminder;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: reminder.dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              if (reminder.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  reminder.subtitle!,
                  style: AppTextStyles.small.copyWith(
                    color: reminder.subtitleColor ?? AppColors.faintText,
                    fontWeight: reminder.subtitleColor != null
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
