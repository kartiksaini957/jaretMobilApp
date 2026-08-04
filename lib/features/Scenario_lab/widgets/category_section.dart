import 'package:flutter/material.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';
import 'radial_wheel_detail.dart';
import 'steps_detail_panel.dart';

enum _DetailKind { steps, radial }

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

/// "Full analysis" grid: Steps to take / Pros / Cons / Keep in mind.
/// Tapping a tile opens its detail panel below.
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
      title: 'Steps to take',
      subtitle: '4 steps · 3 decision gates',
      kind: _DetailKind.steps,
      detail: const StepsDetailPanel(
        stepIndex: 1,
        stepCount: 4,
        title: 'Post the Friday 5–10pm shift this week',
        body:
            "Post the hire before Thursday's dough call so the new "
            "schedule is live for next Friday's peak — every week you "
            'wait is another ≈\$630 of turned-away orders.',
        timeline: 'Post by Wed; first shift covered as soon as Fri 5pm.',
        primaryLabel: 'Continue to financials',
        secondaryLabel: 'See alternatives',
      ),
    ),
    _CategoryData(
      icon: Icons.thumb_up_outlined,
      title: 'Pros',
      subtitle: '3 upsides, each priced',
      kind: _DetailKind.radial,
      detail: const RadialWheelDetail(
        centerLabel: 'Pros',
        segments: [
          'Recovers ≈\$2,700/mo in turned-away orders',
          'Cuts Friday sell-outs to near zero',
          'Frees you from expediting on peak nights',
        ],
      ),
    ),
    _CategoryData(
      icon: Icons.thumb_down_outlined,
      title: 'Cons',
      subtitle: '3 risks, each with a fix',
      kind: _DetailKind.radial,
      borderColor: ScenarioLabColors.statusBad,
      detail: const RadialWheelDetail(
        centerLabel: 'Cons',
        segments: [
          'New-hire ramp takes 2–3 weeks — fix: train on Thu prep first',
          'Cash dips to \$50,600 in month 2 — fix: hold the cheese saving in reserve',
          'Dough batch waste if demand softens — fix: cap Thursday prep at the \$5,200 line',
        ],
      ),
    ),
    _CategoryData(
      icon: Icons.lightbulb_outline,
      title: 'Keep in mind',
      subtitle: '3 landmines advisors flag',
      kind: _DetailKind.radial,
      borderColor: ScenarioLabColors.statusWarn,
      detail: const RadialWheelDetail(
        centerLabel: 'Watch',
        segments: [
          'Recess week (Feb 16–20) will read soft — judge at week 6, not week 2',
          'NY wage/OT rules apply to the added Friday shift',
          'Re-check the hire decision at week 6 against actual recovered orders',
        ],
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
