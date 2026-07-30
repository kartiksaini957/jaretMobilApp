import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_theme.dart';

/// App-wide loading indicator — the Flickr-style two-dot spinner, sized
/// to drop into buttons, cards, or full-screen loading states alike so
/// every "in progress" moment in the app looks the same.
class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.size = 22,
    this.leftDotColor = AppColors.accent,
    this.rightDotColor = AppColors.white,
  });

  final double size;
  final Color leftDotColor;
  final Color rightDotColor;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(
      leftDotColor: leftDotColor,
      rightDotColor: rightDotColor,
      size: size,
    );
  }
}
