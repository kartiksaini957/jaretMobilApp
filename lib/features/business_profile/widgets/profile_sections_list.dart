import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/profile_sections_data.dart';

class ProfileSectionsList extends StatelessWidget {
  const ProfileSectionsList({
    super.key,
    required this.sections,
    required this.onSectionTap,
  });

  final List<ProfileSectionData> sections;
  final ValueChanged<ProfileSectionData> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.glassDark.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassLight),
        ),
        child: Column(
          children: [
            for (var i = 0; i < sections.length; i++)
              _SectionRow(
                data: sections[i],
                showDivider: i != sections.length - 1,
                onTap: () => onSectionTap(sections[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.data,
    required this.showDivider,
    required this.onTap,
  });

  final ProfileSectionData data;
  final bool showDivider;
  final VoidCallback onTap;

  Color get _dotColor => switch (data.status) {
    SectionStatus.complete => AppColors.goodDot,
    SectionStatus.inProgress => AppColors.warnDot,
    SectionStatus.notStarted => AppColors.faintText,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(
                    bottom: BorderSide(color: AppColors.glassBorderSoft),
                  )
                : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text('${data.number}', style: AppTextStyles.small),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.title,
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13.5),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: _dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                data.statusLabel,
                style: AppTextStyles.small.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
