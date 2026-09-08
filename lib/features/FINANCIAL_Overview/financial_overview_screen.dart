import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/model/financialOverviewModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/pref_utils.dart';
// import '../../api_service.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import 'data/financial_overview_data.dart';
// TODO: confirm actual paths for these two data files in your project
import 'data/home_overview_data.dart'
    show applyFinancialOverviewToHome, homeSummaryBody;
import 'data/expense_breakdown_data.dart' show applyFinancialOverviewToExpenses;
import 'widgets/financial_category_tabs.dart';
import 'widgets/financial_metric_detail_card.dart';
import 'widgets/financial_metric_pills.dart';
import 'widgets/financial_status_banner.dart';
import 'widgets/expenses_overview_tab.dart';
import 'widgets/home_overview_tab.dart';
import 'widgets/pressing_now_tab.dart';
import '../../widgets/app_nav_destinations.dart';
// import '../../model/financialOverviewModel.dart';

class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key});

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  static const _homeCategoryIndex = 0;
  static const _pressingNowCategoryIndex = 1;
  static const _ratiosCategoryIndex = 2;
  static const _expensesCategoryIndex = 3;

  int _selectedCategory = _homeCategoryIndex;
  int _selectedMetric = 0;

  late Future<FinancialOverviewResponse> _future;
  ProfitabilityBanner? _banner;
  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<FinancialOverviewResponse> _load() async {
    final token = await PrefUtils.getAccessToken();
    final result = await ApiService().getFinancialOverview(
      accessToken: token ?? '',
    );

    // populate the mutable "dummy" data slots that the tab widgets read from
    metricDetails = metricDetailsFromKpiTiles(result.kpiTiles);
    applyFinancialOverviewToHome(result);
    applyFinancialOverviewToExpenses(result);
    _banner = result.insights.profitabilityBanner;

    return result;
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.financialOverview,
    );
  }

  Widget _buildCategoryContent() {
    if (_selectedCategory == _homeCategoryIndex) {
      return HomeOverviewTab(
        key: const ValueKey('home'),
        onViewPressingTap: () =>
            setState(() => _selectedCategory = _pressingNowCategoryIndex),
      );
    }
    if (_selectedCategory == _pressingNowCategoryIndex) {
      return const PressingNowTab(key: ValueKey('pressingNow'));
    }
    if (_selectedCategory == _ratiosCategoryIndex) {
      return Column(
        key: const ValueKey('ratios'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FinancialMetricPills(
            metrics: metricDetails,
            selectedIndex: _selectedMetric,
            onSelect: (index) => setState(() => _selectedMetric = index),
          ),
          const SizedBox(height: 16),
          if (metricDetails.isNotEmpty)
            FinancialMetricDetailCard(metric: metricDetails[_selectedMetric]),
        ],
      );
    }
    if (_selectedCategory == _expensesCategoryIndex) {
      return const ExpensesOverviewTab(key: ValueKey('expenses'));
    }

    final label = financialCategories[_selectedCategory];
    return Container(
      key: ValueKey(label),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        '$label view is still being built.',
        style: AppTextStyles.small,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Financial Overview',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 2,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: FutureBuilder<FinancialOverviewResponse>(
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
                        'Could not load financial overview.');

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
                            'Financial Overview Unavailable',
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

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FinancialStatusBanner(
                      headline: _banner?.headline.isNotEmpty == true
                          ? _banner!.headline
                          : "You're profitable — nothing pressing this week.",
                      freshnessLabel: 'Updated · synced with your data',
                    ),
                    const SizedBox(height: 14),
                    FinancialCategoryTabs(
                      labels: financialCategories,
                      selectedIndex: _selectedCategory,
                      onSelect: (index) =>
                          setState(() => _selectedCategory = index),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildCategoryContent(),
                    ),
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
