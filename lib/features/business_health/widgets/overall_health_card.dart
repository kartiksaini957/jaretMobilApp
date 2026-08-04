import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'dart:math' show pi;
import '../theme/business_health_colors.dart';

/// Big "74/100" score card at the top of Business Health: the score, a
/// status pill with the change-since line, and the AI confidence summary.
class OverallHealthCard extends StatelessWidget {
  const OverallHealthCard({
    super.key,
    required this.score,
    this.outOf = 100,
    required this.statusLabel,
    this.statusGood = true,
    this.deltaText,
    required this.confidenceText,
  });

  final int score;
  final int outOf;
  final String statusLabel;
  final bool statusGood;
  final String? deltaText;
  final String confidenceText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // First Gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(160 * pi / 180),
          colors: const [
            Color.fromRGBO(8, 40, 56, 0.34),
            Color.fromRGBO(8, 40, 56, 0.30),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
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
              Color.fromRGBO(255, 255, 255, 0.14),
              Color.fromRGBO(255, 255, 255, 0.05),
              Color.fromRGBO(255, 255, 255, 0.03),
            ],
            stops: const [
              0.0, // 0%
              0.4, // 40%
              1.0, // 100%
            ],
          ),
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$score',
                    style: AppTextStyles.headline.copyWith(
                      color: BusinessHealthColors.white,
                      fontSize: 74,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  TextSpan(
                    text: '/$outOf',
                    style: AppTextStyles.headline.copyWith(
                      color: BusinessHealthColors.faintText,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                      255,
                      255,
                      255,
                      0.10,
                    ), // background-color

                    borderRadius: BorderRadius.circular(
                      99,
                    ), // border-radius: 99px

                    border: Border.all(
                      color: const Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.28,
                      ), // border color
                      width: 1,
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: statusGood
                  //       ? BusinessHealthColors.pillGoodBg
                  //       : BusinessHealthColors.trackFill,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: statusGood
                              ? BusinessHealthColors.dotGood
                              : BusinessHealthColors.dotNeutral,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: AppTextStyles.body.copyWith(
                          color: BusinessHealthColors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (deltaText != null) ...[
                  const SizedBox(width: 10),
                  Text(
                    deltaText!,
                    style: AppTextStyles.body.copyWith(
                      color: const Color(0xFFA6F5DC),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            Divider(color: Colors.white, thickness: .1),
            const SizedBox(height: 8),
            Text(
              confidenceText,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: BusinessHealthColors.faintText,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
