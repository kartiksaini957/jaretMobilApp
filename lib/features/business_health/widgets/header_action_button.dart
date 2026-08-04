import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'dart:math' show pi;
import '../theme/business_health_colors.dart';

/// Outline pill button used for "Add a document" / "Refresh" in the
/// header row.
class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(color: BusinessHealthColors.cardBorder),
          // ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            // Border
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.30),
              width: 1.25,
            ),

            // Second Gradient
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(160 * pi / 180),
              colors: const [
                Color.fromRGBO(95, 224, 255, 0.28),
                Color.fromRGBO(95, 224, 255, 0.10),
              ],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: BusinessHealthColors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: BusinessHealthColors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
