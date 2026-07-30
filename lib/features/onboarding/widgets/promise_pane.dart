import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../NotKnow/screens/welcome_screen.dart';

class PromisePane extends StatelessWidget {
  const PromisePane({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Stop guessing.\n', style: AppTextStyles.headline),
              TextSpan(
                text: 'Start knowing.',
                style: AppTextStyles.headlineAccent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'The clarity of a \$500/hr advisor who\'s known your business for 30 years. '
          'It watches your numbers and tells you what to do, before you ask.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 24),
        const _PromiseBullet(
          icon: Icons.lock_outline,
          text: 'Read-only. We never touch your money',
        ),
        const SizedBox(height: 14),
        const _PromiseBullet(
          icon: Icons.gpp_good_outlined,
          text: 'Your data is never sold',
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          },
          child: const _PromiseBullet(
            icon: Icons.link_off,
            text: 'Disconnect anytime, in one click',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PromiseBullet extends StatelessWidget {
  const _PromiseBullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
