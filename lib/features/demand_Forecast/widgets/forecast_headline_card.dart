import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// Top card: status + date range, the headline sentence, the expected
/// dollar figure vs normal, a confidence readout, and the biggest swing
/// factor callout.
class ForecastHeadlineCard extends StatefulWidget {
  const ForecastHeadlineCard({
    super.key,
    required this.data,
    this.showAlt = false,
  });

  final ForecastTabData data;
  final bool showAlt;

  @override
  State<ForecastHeadlineCard> createState() => _ForecastHeadlineCardState();
}

class _ForecastHeadlineCardState extends State<ForecastHeadlineCard> {
  bool _showHowWeGetThisNumber = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final showingAlt = widget.showAlt && data.altValue != null;
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
                  color: data.status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${data.status.badgeText} · ${data.dateRangeLabel}',
                style: AppTextStyles.eyebrow.copyWith(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.headline,
            style: AppTextStyles.headlineAccent.copyWith(
              fontSize: 24,
              height: 1.3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.white, thickness: .1),
          const SizedBox(height: 8),

          Text(
            // 🔧 CHANGED: label value ke saath switch hoti hai
            showingAlt
                ? (data.altLabel ?? '').toUpperCase()
                : 'EXPECTED · ${data.expectedLabel}',
            style: AppTextStyles.eyebrow.copyWith(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            // 🔧 CHANGED: showAlt true ho to covers dikhao, warna dollar value
            showingAlt ? data.altValue! : data.expectedValue,
            style: AppTextStyles.headlineAccent.copyWith(
              fontSize: 34,
              height: 1.3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          if (!showingAlt) // 🔧 NEW: covers mode me dollar-delta badge nahi dikhana
            Row(
              children: [
                Text(
                  data.normalValue,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (data.deltaPositive
                                ? AppColors.goodDot
                                : AppColors.critDot)
                            .withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.deltaLabel,
                    style: TextStyle(
                      color: data.deltaPositive
                          ? AppColors.goodText
                          : AppColors.crit,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => setState(
              () => _showHowWeGetThisNumber = !_showHowWeGetThisNumber,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _showHowWeGetThisNumber
                      ? Icons.keyboard_arrow_down
                      : Icons.chevron_right,
                  size: 16,
                  color: Colors.white,
                ),
                Text(
                  'how we get this number',
                  style: AppTextStyles.small.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          if (_showHowWeGetThisNumber) ...[
            const SizedBox(height: 8),
            _BreakdownLine(label: 'Committed', value: data.breakdown.committed),
            _BreakdownLine(
              label: 'Expected losses',
              value: data.breakdown.expectedLosses,
            ),
            _BreakdownLine(
              label: 'Un-booked demand',
              value: data.breakdown.unbookedDemand,
            ),
            _BreakdownLine(
              label: 'External adjustment',
              value: data.breakdown.externalAdjustment,
            ),
          ],
          const SizedBox(height: 8),
          Divider(color: Colors.white, thickness: .1),
          const SizedBox(height: 8),

          Text(
            'CONFIDENCE',
            style: AppTextStyles.eyebrow.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.confidencePercent}%',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  data.confidenceLabel,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                    color: const Color(0xFFA6F5DC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.confidenceBody,
            style: AppTextStyles.small.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _BreakdownLine extends StatelessWidget {
  const _BreakdownLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.small.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.small.copyWith(height: 1.4)),
        ],
      ),
    );
  }
}
