import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// One numbered accordion section in "Business Profile Questions".
class ProfileQuestionSection extends StatefulWidget {
  const ProfileQuestionSection({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    required this.content,
    this.initiallyExpanded = false,
  });

  final int index;
  final String title;
  final String? subtitle;
  final Widget content;
  final bool initiallyExpanded;

  @override
  State<ProfileQuestionSection> createState() => _ProfileQuestionSectionState();
}

class _ProfileQuestionSectionState extends State<ProfileQuestionSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.index}. ${widget.title}',
                          style: const TextStyle(
                            color: BusinessHealthColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              color: BusinessHealthColors.faintText,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: BusinessHealthColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: !_expanded
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: widget.content,
                  ),
          ),
        ],
      ),
    );
  }
}
