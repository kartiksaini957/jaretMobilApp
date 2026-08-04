import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String text;

  const FilterChipWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),

      decoration: BoxDecoration(
        color: AppColors.glassLight,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: AppColors.glassBorder),
      ),

      child: Row(
        children: [
          Text(text, style: AppTextStyles.link.copyWith(fontSize: 13)),

          const SizedBox(width: 8),

          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
