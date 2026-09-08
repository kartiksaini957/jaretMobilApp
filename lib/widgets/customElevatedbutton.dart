import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'custom_loader.dart';

import 'smooth_animations.dart';

/// Frosted-glass pill button (blurred backdrop + translucent fill) used as
/// the primary call to action on every screen.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && onPressed != null;

    return SmoothScaleTap(
      onTap: isEnabled ? onPressed : null,
      scaleFactor: 0.96,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.white.withValues(alpha: 0.28),
                    AppColors.glassLight,
                    AppColors.white.withValues(alpha: 0.04),
                  ],
                  stops: const [0, 0.4, 1],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: Center(
                  child: isLoading
                      ? const CustomLoader(size: 22)
                      : Text(label, style: AppTextStyles.buttonLabel),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(
        label,
        style: AppTextStyles.link.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: AppColors.white,
        ),
      ),
    );
  }
}
