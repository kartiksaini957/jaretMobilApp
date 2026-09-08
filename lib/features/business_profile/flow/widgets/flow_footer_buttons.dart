import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// Secondary pill (Later/Skip) + primary filled pill (Continue/Save &
/// finish later), the footer row on every flow card.
class FlowFooterButtons extends StatelessWidget {
  const FlowFooterButtons({
    super.key,
    required this.secondaryLabel,
    required this.onSecondary,
    required this.primaryLabel,
    required this.onPrimary,
    this.isPrimaryLoading = false,
  });

  final String secondaryLabel;
  final VoidCallback onSecondary;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final bool isPrimaryLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: isPrimaryLoading ? null : onSecondary,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color.fromRGBO(10, 48, 70, 0.45),
                border: Border.all(
                  color: const Color.fromRGBO(127, 227, 255, 0.35),
                  width: 1.1,
                ),
              ),
              child: Text(
                secondaryLabel,
                style: AppTextStyles.buttonLabel.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: isPrimaryLoading ? null : onPrimary,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color.fromRGBO(16, 120, 155, 0.65),
                border: Border.all(
                  color: const Color.fromRGBO(127, 227, 255, 0.5),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 30, 50, 0.35),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: isPrimaryLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      primaryLabel,
                      style: AppTextStyles.buttonLabel.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

