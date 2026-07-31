import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Top card on the dashboard: date, greeting, and a one-line business
/// summary under a "YOUR BUSINESS RIGHT NOW" eyebrow.
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key, required this.name, required this.summary});

  final String name;
  final String summary;

  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get _firstName => name.trim().split(RegExp(r'\s+')).first;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _today {
    final now = DateTime.now();
    final weekday = _weekdayNames[now.weekday - 1];
    final month = _monthNames[now.month - 1];
    return '$weekday, $month ${now.day}';
  }

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
            _today,
            style: AppTextStyles.small.copyWith(color: AppColors.faintText),
          ),
          const SizedBox(height: 6),
          Text(
            '$_greeting, $_firstName',
            style: AppTextStyles.headline.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 18),
          Divider(),
          const SizedBox(height: 18),

          Text('YOUR BUSINESS RIGHT NOW', style: AppTextStyles.eyebrow),
          const SizedBox(height: 8),
          Text(
            summary,
            style: AppTextStyles.body.copyWith(
              color: AppColors.white,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }
}
