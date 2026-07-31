import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// "How LightSignal sees your business" header: description, last-
/// classified meta + History link, and the view-mode toggle pill.
class ClassificationHeaderCard extends StatelessWidget {
  const ClassificationHeaderCard({
    super.key,
    required this.lastClassifiedLabel,
    required this.showingAllAtOnce,
    required this.onToggleMode,
    required this.onHistoryTap,
  });

  final String lastClassifiedLabel;
  final bool showingAllAtOnce;
  final VoidCallback onToggleMode;
  final VoidCallback onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How LightSignal sees your business',
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 6),
          Text(
            'Built from your profile, your connected Square POS and '
            'QuickBooks Online data, and public sources. Every agent '
            'reads this on every call — correcting anything off '
            'sharpens everything.',
            style: AppTextStyles.small,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('$lastClassifiedLabel · ', style: AppTextStyles.small),
                    InkWell(
                      onTap: onHistoryTap,
                      child: Text(
                        'History →',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onToggleMode,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.glassBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  showingAllAtOnce ? 'One at a time' : 'Show all at once',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
