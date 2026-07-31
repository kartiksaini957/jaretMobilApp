import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// Top card: status + date range, the headline sentence, the expected
/// dollar figure vs normal, a confidence readout, and the biggest swing
/// factor callout.
class ForecastHeadlineCard extends StatefulWidget {
  const ForecastHeadlineCard({super.key, required this.data});

  final ForecastTabData data;

  @override
  State<ForecastHeadlineCard> createState() => _ForecastHeadlineCardState();
}

class _ForecastHeadlineCardState extends State<ForecastHeadlineCard> {
  bool _showHowWeGetThisNumber = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
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
                style: AppTextStyles.eyebrow,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.headline,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 19,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text('EXPECTED · ${data.expectedLabel}', style: AppTextStyles.eyebrow),
          const SizedBox(height: 6),
          Text(
            data.expectedValue,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(data.normalValue, style: AppTextStyles.small),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (data.deltaPositive
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
                  color: AppColors.accent,
                ),
                Text(
                  'how we get this number',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.accent,
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
          const SizedBox(height: 18),
          Text('CONFIDENCE', style: AppTextStyles.eyebrow),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.confidenceBody,
            style: AppTextStyles.small.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warnDot.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warnDot.withValues(alpha: 0.4)),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.small.copyWith(
                  color: AppColors.mutedText,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: '⚡ Biggest swing factor: ',
                    style: TextStyle(
                      color: AppColors.warnDot,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: data.swingFactorBody),
                ],
              ),
            ),
          ),
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
