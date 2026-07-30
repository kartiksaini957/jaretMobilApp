import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// Simple title + muted body card, used for "What's Driving Your Score"
/// and "Priority Watch Areas".
class InsightListCard extends StatelessWidget {
  const InsightListCard({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: BusinessHealthColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: BusinessHealthColors.faintText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Active Health Alerts" card: title + a status row with a checkmark
/// (or warning) icon.
class HealthAlertsCard extends StatelessWidget {
  const HealthAlertsCard({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: BusinessHealthColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(top: 1),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: BusinessHealthColors.goodText,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: BusinessHealthColors.mutedText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
