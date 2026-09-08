import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/business_health/data/full_read_data.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../../utils/pref_utils.dart';
import 'model/businessHealthOverviewModel.dart';
import 'theme/business_health_colors.dart';
import 'widgets/full_read_section.dart';
import 'widgets/header_action_button.dart';
import 'widgets/health_category_card.dart';
import 'widgets/narrative_card.dart';
import 'widgets/overall_health_card.dart';
import 'widgets/snapshot_dropdown_pill.dart';
import 'widgets/snapshot_history_sheet.dart';
import '../../widgets/app_nav_destinations.dart';

class BusinessHealthScreen extends StatefulWidget {
  const BusinessHealthScreen({super.key});

  @override
  State<BusinessHealthScreen> createState() => _BusinessHealthScreenState();
}

class _BusinessHealthScreenState extends State<BusinessHealthScreen> {
  late Future<BusinessHealthOverviewResponse> _future;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<BusinessHealthOverviewResponse> _load() async {
    final token = await PrefUtils.getAccessToken();
    final result = await ApiService().getBusinessHealthOverview(
      accessToken: token ?? '',
    );
    applyBusinessHealthToFullRead(result.data);
    return result;
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.businessHealth,
    );
  }

  Future<void> _onRefreshTap() async {
    if (_isRefreshing)
      return; // already chal raha hai to dobara mat trigger karo

    setState(() => _isRefreshing = true);

    try {
      final token = await PrefUtils.getAccessToken();
      await ApiService().refreshBusinessHealth(accessToken: token ?? '');

      final newFuture = _load();
      setState(() {
        _future = newFuture;
      });
      await newFuture; // naya data load hone tak wait karo
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Refresh failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  String _statusLabel(String label) {
    switch (label) {
      case 'above_average':
        return 'Above Average';
      case 'below_average':
        return 'Below Average';
      case 'top_tier':
        return 'Top Tier';
      default:
        return 'At Average';
    }
  }

  bool _isGood(String label) => label == 'above_average' || label == 'top_tier';

  String _deltaText(int delta) =>
      delta == 0 ? 'steady' : (delta > 0 ? '+$delta' : '$delta');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Health',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 3,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: FutureBuilder<BusinessHealthOverviewResponse>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                final err = snapshot.error;
                final String errMsg = (err is ApiException)
                    ? err.message
                    : (err?.toString().replaceFirst('Exception: ', '') ??
                        'Could not load business health.');

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.glassDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.glassBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.yellow,
                            size: 42,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Business Health Unavailable',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errMsg,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.mutedText,
                              fontSize: 13.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _future = _load();
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Retry',
                                    style: AppTextStyles.small.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final data = snapshot.data!.data;
              final overall = data.overall;
              final cats = data.categories;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SnapshotDropdownPill(
                          label: 'Snapshot · ${overall.asOf}',
                          onTap: () => SnapshotHistorySheet.show(context, [
                            SnapshotEntry(
                              label: '${overall.asOf} — current',
                              score: overall.score,
                              isCurrent: true,
                            ),
                          ]),
                        ),
                        const Spacer(),
                        HeaderActionButton(
                          icon: _isRefreshing
                              ? Icons.hourglass_empty
                              : Icons.refresh,
                          label: _isRefreshing ? 'Refreshing...' : 'Refresh',
                          onTap: _isRefreshing ? () {} : _onRefreshTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF26C281),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'BUSINESS HEALTH · AS OF ${overall.asOf}',
                          style: AppTextStyles.body.copyWith(
                            color: BusinessHealthColors.faintText,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OverallHealthCard(
                      score: overall.score,
                      statusLabel: _statusLabel(overall.label),
                      statusGood: _isGood(overall.label),
                      deltaText:
                          '${_deltaText(overall.delta)} since last snapshot',
                      confidenceText:
                          'AI Confidence ${(overall.aiConfidence * 100).round()}% · '
                          '${overall.dataCompleteness}% data completeness'
                          '${data.dataCoverageNote.isNotEmpty ? ' · ${data.dataCoverageNote}' : ''}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'PROFITABILITY',
                            score: cats.financial.score,
                            deltaText: _deltaText(cats.financial.delta),
                            deltaPositive: cats.financial.delta >= 0,
                            statusText: _statusLabel(cats.financial.label),
                            statusGood: _isGood(cats.financial.label),
                            progress: cats.financial.progress,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'CASH',
                            score: cats.operational.score,
                            deltaText: _deltaText(cats.operational.delta),
                            deltaPositive: cats.operational.delta >= 0,
                            statusText: _statusLabel(cats.operational.label),
                            statusGood: _isGood(cats.operational.label),
                            progress: cats.operational.progress,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'GROWTH',
                            score: cats.growth.score,
                            deltaText: _deltaText(cats.growth.delta),
                            deltaPositive: cats.growth.delta >= 0,
                            statusText: _statusLabel(cats.growth.label),
                            statusGood: _isGood(cats.growth.label),
                            progress: cats.growth.progress,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'CUSTOMERS',
                            score: cats.customer.score,
                            deltaText: _deltaText(cats.customer.delta),
                            deltaPositive: cats.customer.delta >= 0,
                            statusText: _statusLabel(cats.customer.label),
                            statusGood: _isGood(cats.customer.label),
                            progress: cats.customer.progress,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'RISK',
                            score: cats.risk.score,
                            deltaText: _deltaText(cats.risk.delta),
                            deltaPositive: cats.risk.delta >= 0,
                            statusText: _statusLabel(cats.risk.label),
                            statusGood: _isGood(cats.risk.label),
                            progress: cats.risk.progress,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HealthCategoryCard(
                            title: 'PEERS',
                            score: data.benchmarks.peerAvg,
                            statusText: data.benchmarks.peerPool,
                            progress: data.benchmarks.peerAvg / 100.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NarrativeCard(text: data.aiSummary),
                    // NOTE: PreviousSnapshotCard removed — this API has no
                    // historical snapshot data (only prior_score numbers).
                    // Bata do agar snapshot-history endpoint hai, use bhi wire kar dunga.
                    const SizedBox(height: 20),
                    const FullReadSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
