import 'package:flutter_riverpod/legacy.dart';

/// Tracks which onboarding pane is currently visible so the dot indicator
/// can stay in sync with the PageView.
final onboardingPageProvider = StateProvider<int>((ref) => 0);

const onboardingPageCount = 3;
