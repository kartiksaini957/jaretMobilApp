import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/customElevatedbutton.dart';
import '../../../widgets/gradient_background.dart';
import 'business_snapshot_screen.dart';

/// Screen 1 — Welcome.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'The advisor who\'s known your business for ',
                        style: AppTextStyles.headline,
                      ),
                      TextSpan(
                        text: 'thirty years.',
                        style: AppTextStyles.headlineAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                 Text(
                  'In about ten minutes you\'ll see your first real read, '
                  'pulled from your own numbers, in plain language. No '
                  'spreadsheets, no jargon. We\'ll show you something '
                  'useful at each step along the way.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 24),
                const Spacer(),
                PrimaryButton(
                  label: 'Let\'s start',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BusinessSnapshotScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                 Center(
                  child: Text(
                    'Takes about 10 minutes',
                    style: AppTextStyles.small,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
