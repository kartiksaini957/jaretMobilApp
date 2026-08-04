import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/customElevatedbutton.dart';
import '../../../widgets/gradient_background.dart';
import '../widgets/connection_card.dart';
import '../widgets/step_progress_bar.dart';
import 'profile_start_screen.dart';

/// Screen 4 — Connect books (step 3 of 3).
class ConnectBooksScreen extends StatelessWidget {
  const ConnectBooksScreen({super.key});

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

                        const StepProgressBar(step: 3, totalSteps: 3),
                        const SizedBox(height: 5),

                        Text(
                          'STEP 3 OF 3 · CONNECT BOOKS',
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'This is where it ',
                                style: AppTextStyles.headline.copyWith(
                                  fontSize: 23,
                                ),
                              ),
                              TextSpan(
                                text: 'gets real.',
                                style: AppTextStyles.headlineAccent.copyWith(
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Connect read-only. We can never move money or change a '
                          'record, we only read, so we can tell you what\'s going '
                          'on. One minute, and your first read starts building.',
                          style: AppTextStyles.body.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 22),
                        const ConnectionCard(
                          name: 'QuickBooks Online',
                          description:
                              'Reads your income, expenses, and history.',
                          isConnected: true,
                        ),
                        const SizedBox(height: 12),
                        ConnectionCard(
                          name: 'Square',
                          description:
                              'If you take payments through Square, connect it too.',
                          onConnect: () {},
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'On a different system? Xero, Toast, and others are '
                          'supported.',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.faintText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'We already see 14 months of history.',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enough to start reading your margins and cash today, '
                          'not weeks from now. Syncing now.',
                          style: AppTextStyles.body.copyWith(
                            color: const Color(0xFFA6F5DC),
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Spacer(),
                        PrimaryButton(
                          label: 'Continue',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ProfileStartScreen(),
                              ),
                            );
                          },
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
