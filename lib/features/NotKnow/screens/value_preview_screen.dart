import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/customElevatedbutton.dart';
import '../../../widgets/gradient_background.dart';
import '../widgets/feature_bullet.dart';
import '../widgets/secondary_button.dart';
import '../widgets/step_progress_bar.dart';
import 'connect_books_screen.dart';

/// Screen 3 — Value preview (step 2 of 3).
class ValuePreviewScreen extends StatelessWidget {
  const ValuePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppLogo(),
                        const SizedBox(height: 24),

                        const StepProgressBar(step: 2, totalSteps: 3),
                        const SizedBox(height: 5),

                        Text(
                          'STEP 2 OF 3 · WHAT WE\'LL DO',
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Based on what you told us, LightSignal will...',
                          style: AppTextStyles.headline.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassDark,
                            borderRadius: BorderRadius.circular(14),
                            // border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'You said ',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.mutedText,
                                  fontSize: 13,
                                  // fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'slow weeks blindside you',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  // fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        const FeatureBullet(
                          icon: Icons.bar_chart,
                          title: 'Forecast demand by day and week',
                          subtitle:
                              'So a slow stretch shows up before it hits, not after.',
                        ),
                        const SizedBox(height: 16),
                        const FeatureBullet(
                          icon: Icons.visibility_outlined,
                          title: 'Watch your cash and flag it early',
                          subtitle:
                              'Before a soft week turns into a tight one.',
                        ),
                        const SizedBox(height: 16),
                        const FeatureBullet(
                          icon: Icons.favorite_border,
                          title: 'A health score you can actually read',
                          subtitle: 'And tell you when it moves.',
                        ),
                        const SizedBox(height: 16),
                        const FeatureBullet(
                          icon: Icons.auto_awesome_outlined,
                          title: 'Find real opportunities near you',
                          subtitle:
                              'Catering, events, slow-day promotions worth your time.',
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'To do this with your real numbers, we need to read your '
                          'books. That\'s next. It takes about a minute.',
                          style: AppTextStyles.body.copyWith(fontSize: 12.5),
                        ),
                        const SizedBox(height: 24),
                        const Spacer(),
                        Row(
                          children: [
                            SecondaryButton(
                              label: 'Back',
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                label: 'Connect my books',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ConnectBooksScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
