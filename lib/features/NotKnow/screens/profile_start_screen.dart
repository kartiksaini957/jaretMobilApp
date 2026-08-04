import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/customElevatedbutton.dart';
import '../../../widgets/gradient_background.dart';
import '../widgets/note_card.dart';

/// Screen 5 — Profile start / first read building.
class ProfileStartScreen extends StatelessWidget {
  const ProfileStartScreen({super.key});

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
                        Text(
                          'FIRST READ IS BUILDING',
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'While that syncs, the more we know, the ',
                                style: AppTextStyles.headline.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              TextSpan(
                                text: 'sharper we get.',
                                style: AppTextStyles.headlineAccent.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              // TextSpan(
                              //   text: '',
                              //   style: AppTextStyles.headline.copyWith(
                              //     fontSize: 22,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your books give us the numbers. A few more details '
                          'about how your business actually runs, and every read '
                          'gets sharper. Fill what you can now, come back for the '
                          'rest anytime.',
                          style: AppTextStyles.body.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'How well we understand your business',
                                style: AppTextStyles.small,
                              ),
                            ),
                            Text(
                              'Building',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 7.9,
                            child: Stack(
                              children: [
                                // Background
                                Container(
                                  color: AppColors.white.withValues(
                                    alpha: 0.14,
                                  ),
                                ),

                                // Progress
                                FractionallySizedBox(
                                  widthFactor: 0.30, // 22%
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight, // 90deg
                                        colors: [
                                          Color(0xFF5FE0FF),
                                          Color(0xFF0E9ED0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        NoteCard(
                          eyebrow: 'A BUSINESS NEAR YOU',
                          body: TextSpan(
                            children: [
                              TextSpan(text: 'A restaurant near you found '),
                              TextSpan(
                                text: '\$3,200 a month',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.goodText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' in a produce vendor they were overpaying. Add '
                                    'your expense details and we\'ll run the same '
                                    'check on your books.',
                              ),
                            ],
                          ),
                          footer:
                              'Typical pattern from similar businesses. Not a '
                              'specific customer.',
                        ),
                        const SizedBox(height: 24),
                        const Spacer(),
                        PrimaryButton(
                          label: 'Start with expenses',
                          onPressed: () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst),
                            child: Text(
                              'Skip for now, show my dashboard',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
