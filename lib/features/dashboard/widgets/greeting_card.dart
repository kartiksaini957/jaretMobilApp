import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/shimmer_box.dart';
import '../../../widgets/typewriter_text.dart';

/// Top card on the dashboard: date, greeting, and a one-line business
/// summary under a "YOUR BUSINESS RIGHT NOW" eyebrow.
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.name,
    required this.summary,
    this.isLoading = false,
  });

  final String name;
  final String summary;

  /// Swaps the summary text for shimmer lines while insights are in flight.
  final bool isLoading;

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
      padding: const EdgeInsets.all(18),
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
            style: AppTextStyles.small.copyWith(
              color: AppColors.appfaintText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_greeting, $_firstName',
            style: AppTextStyles.headline.copyWith(fontSize: 25),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white, height: 0.1, thickness: 0.1),
          const SizedBox(height: 10),

          Text(
            'YOUR BUSINESS RIGHT NOW',
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.mute,
              fontSize: 11.0,
              height: 1.54,
            ),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const _SummaryShimmer()
          else
            TypewriterText(
              // Keyed on the sentence so a fresh summary mounts a fresh
              // animation instead of continuing the previous one.
              key: ValueKey(summary),
              text: summary,
              style: AppTextStyles.headline.copyWith(
                color: AppColors.white,
                height: 1.54,
                // letterSpacing: -0.2,
                fontSize: 20.0,
                // height: 26.4,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Two-and-a-bit shimmer lines standing in for the summary sentence, sized
/// to roughly the line height of the real text so the card doesn't jump.
class _SummaryShimmer extends StatelessWidget {
  const _SummaryShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: 18, borderRadius: 6),
        SizedBox(height: 10),
        ShimmerBox(height: 18, borderRadius: 6),
        SizedBox(height: 10),
        FractionallySizedBox(
          widthFactor: 0.55,
          child: ShimmerBox(height: 18, borderRadius: 6),
        ),
      ],
    );
  }
}
