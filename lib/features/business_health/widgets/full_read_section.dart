import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'dart:math' show pi;
import '../data/full_read_data.dart';
import '../theme/business_health_colors.dart';
import 'read_item_tile.dart';

/// "THE FULL READ" section: a scrollable tab row (Working for you /
/// Dragging you down / Watch areas / Alerts) and the expandable item
/// list for whichever tab is selected.
class FullReadSection extends StatefulWidget {
  const FullReadSection({super.key});

  @override
  State<FullReadSection> createState() => _FullReadSectionState();
}

class _FullReadSectionState extends State<FullReadSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final category = fullReadCategories[_selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE FULL READ',
          style: AppTextStyles.body.copyWith(
            color: const Color(0xFFA7DCF0),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < fullReadCategories.length; i++) ...[
                if (i != 0) const SizedBox(width: 8),
                _TabPill(
                  data: fullReadCategories[i],
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            // First Gradient
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(160 * pi / 180),
              colors: const [
                Color.fromRGBO(8, 40, 56, 0.34),
                Color.fromRGBO(8, 40, 56, 0.30),
              ],
            ),
          ),

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              // Border
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.30),
                width: 1.25,
              ),

              // Second Gradient
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(160 * pi / 180),
                colors: const [
                  Color.fromRGBO(255, 255, 255, 0.14),
                  Color.fromRGBO(255, 255, 255, 0.05),
                  Color.fromRGBO(255, 255, 255, 0.03),
                ],
                stops: const [
                  0.0, // 0%
                  0.4, // 40%
                  1.0, // 100%
                ],
              ),
            ),
            // decoration: BoxDecoration(
            //   color: BusinessHealthColors.cardFill,
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(color: BusinessHealthColors.cardBorder),
            // ),
            child: Column(
              key: ValueKey(_selected),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF26C281),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category.badgeText,
                        style: AppTextStyles.body.copyWith(
                          color: BusinessHealthColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.cardTitle,
                        style: AppTextStyles.headline.copyWith(
                          color: BusinessHealthColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${category.count} ${category.countLabel}',
                      style: AppTextStyles.body.copyWith(
                        color: BusinessHealthColors.faintText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                Divider(color: BusinessHealthColors.white, thickness: .2),
                const SizedBox(height: 3),
                for (final item in category.items) ReadItemTile(item: item),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final ReadCategoryData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: BusinessHealthColors.cardFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? const Color(0x805FE0FF)
                  : BusinessHealthColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: data.badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${data.tabLabel}  ',
                style: AppTextStyles.body.copyWith(
                  color: selected
                      ? BusinessHealthColors.white
                      : BusinessHealthColors.faintText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: BusinessHealthColors.cardBorder,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "${data.count}",
                    style: AppTextStyles.body.copyWith(
                      color: selected
                          ? BusinessHealthColors.white
                          : BusinessHealthColors.faintText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
