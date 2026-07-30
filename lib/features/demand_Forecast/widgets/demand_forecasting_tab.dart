import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';
import 'demand_card.dart';
import 'demand_footer.dart';
import 'empty_forecast_chart.dart';
import 'metric_pill_row.dart';

/// "Demand Forecasting" tab: outlook summary, rolling forecast chart,
/// what's driving demand, and next-step guidance.
class DemandForecastingTab extends StatelessWidget {
  const DemandForecastingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Demand Outlook — Next 30 Days',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Loading demand outlook...',
                style: TextStyle(color: DemandColors.faintText, fontSize: 12.5),
              ),
              SizedBox(height: 16),
              MetricPillRow(
                label: 'Demand Risk Level',
                detail: 'Not enough data yet to score risk.',
              ),
              SizedBox(height: 10),
              MetricPillRow(
                label: 'Model Confidence',
                detail: 'Confidence builds as more history syncs in.',
              ),
              SizedBox(height: 10),
              MetricPillRow(
                label: 'Volatility',
                detail: 'No volatility signal yet for this period.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rolling Demand Forecast',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Projected demand — \$0 over next 30 days',
                style: TextStyle(color: DemandColors.faintText, fontSize: 12.5),
              ),
              SizedBox(height: 14),
              EmptyForecastChart(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "What's Driving Demand",
          style: TextStyle(
            color: DemandColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Events & External Factors',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'No local events detected for the forecast period.',
                style: TextStyle(color: DemandColors.mutedText, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather & Seasonality',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Weather Influence — N/A',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: LinearProgressIndicator(
                  value: 0,
                  minHeight: 5,
                  backgroundColor: DemandColors.white,
                  color: DemandColors.actionButton,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Seasonality Effect',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              _DarkInsetBox(text: 'No seasonal data available'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peer & Industry Context',
                style: TextStyle(
                  color: DemandColors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'No peer context available.',
                style: TextStyle(color: DemandColors.mutedText, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'What you Should Do Next',
          style: TextStyle(
            color: DemandColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 420;
            final guidance = const _PreparationGuidanceCard();
            final scenario = const _ScenarioImpactCard();
            if (isNarrow) {
              return Column(
                children: [
                  guidance,
                  const SizedBox(height: 12),
                  scenario,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: guidance),
                const SizedBox(width: 12),
                Expanded(child: scenario),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const DemandFooter(),
      ],
    );
  }
}

class _DarkInsetBox extends StatelessWidget {
  const _DarkInsetBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DemandColors.darkInset,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: DemandColors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PreparationGuidanceCard extends StatelessWidget {
  const _PreparationGuidanceCard();

  static const _items = [
    (Icons.warning_amber_rounded, 'Monitor model confidence'),
    (Icons.info_outline, 'Stay adaptable to changes'),
    (Icons.person_outline, 'Monitor staffing levels'),
  ];

  @override
  Widget build(BuildContext context) {
    return DemandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preparation Guidance',
            style: TextStyle(
              color: DemandColors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_items[i].$1, size: 16, color: DemandColors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _items[i].$2,
                    style: const TextStyle(
                      color: DemandColors.mutedText,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ScenarioImpactCard extends StatelessWidget {
  const _ScenarioImpactCard();

  @override
  Widget build(BuildContext context) {
    return DemandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scenario Impact Preview',
            style: TextStyle(
              color: DemandColors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hypothetical — run full simulation to confirm',
            style: TextStyle(color: DemandColors.faintText, fontSize: 11.5),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: DemandColors.darkInset,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Text(
                        'Run Full Simulation',
                        style: TextStyle(
                          color: DemandColors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 30, color: DemandColors.cardBorder),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Text(
                        '→ Scenario Planning Lab',
                        style: TextStyle(
                          color: DemandColors.mutedText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
