import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';
import 'note_detail_panel.dart';
import 'radial_wheel_detail.dart';
import 'steps_detail_panel.dart';

enum _DetailKind { steps, radial, note }

class _CategoryData {
  const _CategoryData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.kind,
    this.borderColor,
    this.detail,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final _DetailKind kind;
  final Color? borderColor;
  final Widget? detail;
}

/// "Full analysis" grid: Steps / Pros / Cons / Watch-outs / Peer
/// outcomes / Alternatives. Tapping a tile opens its detail panel below.
class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? _selected;

  late final List<_CategoryData> _categories = [
    _CategoryData(
      icon: Icons.checklist,
      title: 'Steps',
      subtitle: 'What to do, in order',
      kind: _DetailKind.steps,
      detail: const StepsDetailPanel(
        stepIndex: 1,
        stepCount: 1,
        title: 'Secure the mobile permit first',
        body:
            'Apply for the Mobile AL vendor permit before signing the '
            "lease — it's the long pole and gates everything else.",
        timeline: 'Budget 3-4 weeks for approval; start this week.',
        primaryLabel: 'Continue to financials',
        secondaryLabel: 'See alternatives',
      ),
    ),
    _CategoryData(
      icon: Icons.thumb_up_outlined,
      title: 'Pros',
      subtitle: 'Why this works',
      kind: _DetailKind.radial,
      detail: const RadialWheelDetail(
        centerLabel: 'Pros',
        segments: [
          'Higher foot traffic',
          'Catering upside',
          'Lower rent per sqft',
        ],
      ),
    ),
    _CategoryData(
      icon: Icons.thumb_down_outlined,
      title: 'Cons / risks',
      subtitle: 'What could bite',
      kind: _DetailKind.radial,
      borderColor: ScenarioLabColors.statusBad,
      detail: const RadialWheelDetail(
        centerLabel: 'Cons',
        segments: ['Cash dips negative', 'Staff ramp', 'Build-out delay risk'],
      ),
    ),
    _CategoryData(
      icon: Icons.lightbulb_outline,
      title: 'Watch-outs',
      subtitle: 'Keep an eye on',
      kind: _DetailKind.radial,
      borderColor: ScenarioLabColors.glow,
      detail: const RadialWheelDetail(
        centerLabel: 'Watch-outs',
        segments: ['Keep DSO under 35', 'Reserve floor', 'Cap marketing'],
      ),
    ),
    _CategoryData(
      icon: Icons.groups_outlined,
      title: 'Peer outcomes',
      subtitle: 'How others did',
      kind: _DetailKind.note,
      detail: const NoteDetailPanel(
        eyebrow: 'PEER OUTCOME',
        headline: 'Similar food trucks averaged 2.4× ROI',
        body:
            'Across 5 comparable Mobile AL operators, transition-to-storefront '
            'moves returned ~2.4× over 24 months.',
        footnote:
            "3 of 5 hit break-even by month 5; the 2 that didn't "
            'under-budgeted build-out.',
      ),
    ),
    _CategoryData(
      icon: Icons.alt_route,
      title: 'Alternatives',
      subtitle: 'Other paths',
      kind: _DetailKind.note,
      detail: const NoteDetailPanel(
        eyebrow: 'ALTERNATIVE',
        headline: 'Stay mobile, add a second truck',
        body: 'Lower capital, faster payback, but caps catering upside.',
        footnote:
            'Consider if you want to defer the lease commitment another quarter.',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full analysis',
          style: TextStyle(
            color: ScenarioLabColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final itemWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (var i = 0; i < _categories.length; i++)
                  SizedBox(
                    width: itemWidth,
                    child: _CategoryTile(
                      data: _categories[i],
                      selected: _selected == i,
                      onTap: () =>
                          setState(() => _selected = _selected == i ? null : i),
                    ),
                  ),
              ],
            );
          },
        ),
        if (_selected != null) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ScenarioLabColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _categories[_selected!].title,
                          style: const TextStyle(
                            color: ScenarioLabColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _selected = null),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: ScenarioLabColors.faintText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _categories[_selected!].detail,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _CategoryData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? (data.borderColor ?? ScenarioLabColors.glow)
        : ScenarioLabColors.cardBorder;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ScenarioLabColors.cardFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(data.icon, size: 18, color: ScenarioLabColors.white),
              const SizedBox(height: 10),
              Text(
                data.title,
                style: const TextStyle(
                  color: ScenarioLabColors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                style: const TextStyle(
                  color: ScenarioLabColors.faintText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
