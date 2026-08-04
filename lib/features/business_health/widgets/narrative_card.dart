import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'dart:ui';
import '../theme/business_health_colors.dart';

/// Plain bordered paragraph card used for the AI narrative under a score
/// (current month or a past snapshot).
class NarrativeCard extends StatelessWidget {
  const NarrativeCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.24),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(95, 224, 255, 0.12),
            Color.fromRGBO(95, 224, 255, 0.04),
          ],
        ),
        boxShadow: const [
          // Blue glow
          BoxShadow(
            color: Color.fromRGBO(95, 224, 255, 0.28),
            blurRadius: 30,
            spreadRadius: -6,
            offset: Offset(0, 0),
          ),

          // Bottom shadow
          BoxShadow(
            color: Color.fromRGBO(0, 20, 40, 0.35),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: BusinessHealthColors.mutedText,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
