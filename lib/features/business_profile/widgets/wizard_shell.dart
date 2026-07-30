import 'package:flutter/material.dart';

import '../theme/business_profile_colors.dart';

/// Row of thin dash segments showing progress through the wizard.
class WizardProgressBar extends StatelessWidget {
  const WizardProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= total; i++)
          Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: i <= current
                    ? BusinessProfileColors.white
                    : BusinessProfileColors.fieldBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}

/// The big glass card every wizard section renders inside, with a title
/// row (+ decorative gear icon) up top.
class WizardSectionCard extends StatelessWidget {
  const WizardSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BusinessProfileColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BusinessProfileColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: BusinessProfileColors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.settings,
                size: 18,
                color: BusinessProfileColors.faintText,
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

/// Back / primary action / Skip footer row shared by every step.
class WizardFooter extends StatelessWidget {
  const WizardFooter({
    super.key,
    required this.onBack,
    required this.onNext,
    this.onSkip,
    this.nextLabel = 'Save & Next',
  });

  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: onBack,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: BusinessProfileColors.fieldBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
          child: const Text(
            'Back',
            style: TextStyle(
              color: BusinessProfileColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: BusinessProfileColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            elevation: 0,
          ),
          child: Text(
            nextLabel,
            style: const TextStyle(
              color: Color(0xFF0C8F86),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (onSkip != null) ...[
          const SizedBox(width: 12),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: BusinessProfileColors.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
