import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';

/// Export/PDF-CSV actions on the left, model confidence status on the
/// right. Wraps on narrow widths instead of overflowing.
class DemandFooter extends StatelessWidget {
  const DemandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: DemandColors.cardBorder),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _PillButton(
              icon: Icons.download_outlined,
              label: 'Export',
              onTap: () {},
            ),
            _PillButton(label: 'PDF / CSV', onTap: () {}),
            Text(
              'Model: — · Confidence: 0%',
              style: const TextStyle(
                color: DemandColors.faintText,
                fontSize: 12.5,
              ),
            ),
            _PillButton(label: 'Model Confidence', onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({this.icon, required this.label, required this.onTap});

  final IconData? icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DemandColors.actionButton,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: DemandColors.white),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: DemandColors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
