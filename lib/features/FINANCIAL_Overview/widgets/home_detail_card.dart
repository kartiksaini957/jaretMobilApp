import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/home_overview_data.dart';

/// Detail panel for the selected Home carousel card: badge + headline,
/// a stat pill, and the What's going on / Why it matters now / What to
/// do (/ Expected outcome) expandable sections.
class HomeDetailCard extends StatefulWidget {
  const HomeDetailCard({super.key, required this.card});

  final HomeStoryCard card;

  @override
  State<HomeDetailCard> createState() => _HomeDetailCardState();
}

class _HomeDetailCardState extends State<HomeDetailCard> {
  late List<bool> _expanded = _initialExpanded();
  bool _viewed = false;
  bool _snoozed = false;

  List<bool> _initialExpanded() => [true, false, false, false];

  @override
  void didUpdateWidget(covariant HomeDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card != widget.card) {
      _expanded = _initialExpanded();
      _viewed = false;
      _snoozed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
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
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: card.status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                card.status.label,
                style: AppTextStyles.small.copyWith(fontSize: 10),
                // TextStyle(
                //   color: card.status.color,
                //   fontSize: 11,
                //   fontWeight: FontWeight.w800,
                //   letterSpacing: 0.4,
                // ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.headline,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 19,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          _Illustration(color: card.status.color),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: card.status.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  card.statLabel,
                  style: AppTextStyles.headlineAccent.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: "What's going on",
            expanded: _expanded[0],
            onTap: () => setState(() => _expanded[0] = !_expanded[0]),
            child: Text(
              card.whatsGoingOn,
              style: AppTextStyles.small.copyWith(height: 1.5),
            ),
          ),
          _Section(
            title: 'Why it matters now',
            expanded: _expanded[1],
            onTap: () => setState(() => _expanded[1] = !_expanded[1]),
            child: Text(
              card.whyItMattersNow,
              style: AppTextStyles.small.copyWith(height: 1.5),
            ),
          ),
          _Section(
            title: 'What to do',
            expanded: _expanded[2],
            onTap: () => setState(() => _expanded[2] = !_expanded[2]),
            showDivider: card.expectedOutcome == null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.glassLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(
                card.whatToDo,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (card.expectedOutcome != null) ...[
            _Section(
              title: 'Expected outcome',
              expanded: _expanded[3],
              onTap: () => setState(() => _expanded[3] = !_expanded[3]),
              showDivider: false,
              child: _ExpectedOutcomeBody(outcome: card.expectedOutcome!),
            ),
            const SizedBox(height: 4),
            _ActionButtons(
              outcome: card.expectedOutcome!,
              viewed: _viewed,
              snoozed: _snoozed,
              onPrimaryTap: () => setState(() => _viewed = true),
              onSecondaryTap: () => setState(() => _snoozed = true),
            ),
          ],
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-14, -6),
              child: _DocOutline(),
            ),
            Transform.translate(
              offset: const Offset(6, 4),
              child: _DocOutline(),
            ),
            Positioned(
              right: 46,
              bottom: 6,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocOutline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 66,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 3,
              width: double.infinity,
              color: AppColors.glassBorder,
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.expanded,
    required this.onTap,
    required this.child,
    this.showDivider = true,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;
  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  size: 18,
                  color: AppColors.faintText,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
        if (showDivider)
          const Divider(height: 1, color: AppColors.glassBorderSoft),
      ],
    );
  }
}

class _ExpectedOutcomeBody extends StatelessWidget {
  const _ExpectedOutcomeBody({required this.outcome});

  final ExpectedOutcome outcome;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPECTED IMPACT',
          style: AppTextStyles.small.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          outcome.impactLabel,
          style: const TextStyle(
            color: AppColors.goodText,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          outcome.impactDetail,
          style: AppTextStyles.small.copyWith(height: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EFFORT',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    outcome.effort,
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONFIDENCE',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    outcome.confidence,
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.outcome,
    required this.viewed,
    required this.snoozed,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final ExpectedOutcome outcome;
  final bool viewed;
  final bool snoozed;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onPrimaryTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: viewed ? AppColors.goodDot : AppColors.glassBorder,
              ),
              backgroundColor: viewed
                  ? AppColors.goodDot.withValues(alpha: 0.16)
                  : null,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              viewed ? '✓ Done' : outcome.primaryActionLabel,
              style: TextStyle(
                color: viewed ? AppColors.goodText : AppColors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: onSecondaryTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: snoozed ? AppColors.goodDot : AppColors.glassBorder,
              ),
              backgroundColor: snoozed
                  ? AppColors.goodDot.withValues(alpha: 0.16)
                  : null,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              snoozed ? '✓ Snoozed' : outcome.secondaryActionLabel,
              style: TextStyle(
                color: snoozed ? AppColors.goodText : AppColors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
