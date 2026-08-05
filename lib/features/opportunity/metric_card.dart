import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'opportunities_screen.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String? badge;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: glassDecoration(),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: AppTextStyles.eyebrow,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // The grid cell is a fixed height, so on a narrow phone — or
              // at a large text scale — the three lines can outgrow it.
              // Giving the value the leftover space and letting it scale
              // down keeps the card intact instead of overflowing.
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Text(
                subtitle,
                style: AppTextStyles.small.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          if (badge != null)
            Positioned(
              right: 0,

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  badge!,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
