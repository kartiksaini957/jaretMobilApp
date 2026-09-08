import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/demand_Forecast/model/demandForecastModel.dart';
import 'package:flutter_application_1/utils/pref_utils.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import 'data/demand_forecast_data.dart';
import 'widgets/forecast_full_read_section.dart';
import 'widgets/forecast_headline_card.dart';
import 'widgets/forecast_tab_pills.dart';
import '../../widgets/app_nav_destinations.dart';

class DemandForecastScreen extends StatefulWidget {
  const DemandForecastScreen({super.key});

  @override
  State<DemandForecastScreen> createState() => _DemandForecastScreenState();
}

class _DemandForecastScreenState extends State<DemandForecastScreen> {
  // static const _tabs = [
  //   'This weekend',
  //   'Rest of month',
  //   '\$ / Covers',
  // ]; // 🔧 CHANGED: label "$ / slices" se "$ / Covers"
  int _selectedTab = 0;
  bool _showCovers = false;
  late Future<DemandForecastResponse> _future;
  List<ForecastWindow>? _windows;
  Set<String> _completedIds = {};
  @override
  void initState() {
    super.initState();
    _fetchForecastData();
    _loadCompletedActions();
  }

  void _fetchForecastData() {
    _future = _loadForecast();
    _future.then((resp) {
      if (mounted) {
        setState(() => _windows = resp.agentOutput.windows);
      }
    }).catchError((e) {
      debugPrint('[DemandForecastScreen] Handled forecast load error: $e');
      if (mounted) {
        setState(() => _windows = null);
      }
    });
  }
  Future<void> _loadCompletedActions() async {
    try {
      final token = await PrefUtils.getAccessToken();
      final ids = await ApiService().getCompletedActions(
        accessToken: token ?? '',
      );
      if (mounted) {
        setState(() => _completedIds = ids.toSet());
      }
    } catch (e) {
      debugPrint('[DemandForecastScreen] failed to load completed actions: $e');
      // fail silently — sab actions unticked dikhenge, crash nahi hoga
    }
  }

  // 🔧 NEW: checkbox tap hone par ye call hoga (child widget se callback aayega)
  Future<void> _toggleActionCompletion(String actionId, bool newValue) async {
    // Optimistic update — turant UI badal do
    setState(() {
      if (newValue) {
        _completedIds.add(actionId);
      } else {
        _completedIds.remove(actionId);
      }
    });

    try {
      final token = await PrefUtils.getAccessToken();
      await ApiService().updateActionCompletion(
        accessToken: token ?? '',
        actionId: actionId,
        completed: newValue,
      );
    } catch (e) {
      debugPrint('[DemandForecastScreen] failed to update action: $e');
      // Rollback agar API call fail ho jaye
      if (mounted) {
        setState(() {
          if (newValue) {
            _completedIds.remove(actionId);
          } else {
            _completedIds.add(actionId);
          }
        });
      }
    }
  }

  Future<DemandForecastResponse> _loadForecast() async {
    final token = await PrefUtils.getAccessToken();
    return ApiService().getDemandForecast(accessToken: token ?? '');
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.demandForecast,
    );
  }

  // 🔧 NEW: current selected tab ke window me covers/volume data hai ya nahi check karo
  bool get _currentTabHasAlt {
    final windows = _windows;
    if (windows == null || windows.isEmpty) return false;

    final window = _selectedTab == 0
        ? windows.firstWhere(
            (w) => w.window == 'This Weekend',
            orElse: () => windows[0],
          )
        : windows.firstWhere(
            (w) => w.window == 'Next 30 Days',
            orElse: () => windows.length > 1 ? windows[1] : windows[0],
          );

    return window.hero.volumeForecast != null &&
        window.hero.volumeUnit != null &&
        window.hero.volumeUnit!.isNotEmpty;
  }

  // 🔧 NEW: 3rd pill sirf tab list me aayega jab current tab ke data me covers ho
  List<String> get _tabs {
    final labels = ['This weekend', 'Rest of month'];
    if (_currentTabHasAlt) labels.add('\$ / Covers');
    return labels;
  }

  Widget _buildTabContent(ForecastTabData data) {
    return Column(
      key: ValueKey(_selectedTab == 0 ? 'thisWeekend' : 'restOfMonth'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ForecastHeadlineCard(data: data, showAlt: _showCovers),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(51, 13, 61, 85),
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.small.copyWith(
                color: AppColors.mutedText,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '⚡ Biggest swing factor: ',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${data.swingFactorBody}',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ForecastFullReadSection(
  data: data,
  onToggleAction: _toggleActionCompletion, // 🔧 NEW
),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Demand Forecast',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 1,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ForecastTabPills(
                  labels: _tabs,
                  selectedIndex: _selectedTab,
                  onSelect: (index) {
                    if (index == 2) {
                      setState(() => _showCovers = !_showCovers);
                    } else {
                      setState(() {
                        _selectedTab = index;
                        // 🔧 NEW: tab badalte hi covers-view reset kar do
                        _showCovers = false;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<DemandForecastResponse>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      final err = snapshot.error;
                      final String errMsg = (err is ApiException)
                          ? err.message
                          : (err?.toString().replaceFirst('Exception: ', '') ??
                              'Could not load demand forecast.');

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
                                  'Demand Forecast Unavailable',
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
                                      _fetchForecastData();
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
                    final windows = snapshot.data!.agentOutput.windows;
                    if (windows.isEmpty) {
                      return Center(
                        child: Text(
                          'No forecast data available.',
                          style: AppTextStyles.small,
                        ),
                      );
                    }

                    // 🔧 FIX: _selectedTab ke hisaab se sahi window dhoondo.
                    // Tab 0 = "This weekend" → window.window == "This Weekend"
                    // Tab 1 = "Rest of month" → window.window == "Next 30 Days"
                    // (agar naam match na ho to index se fallback lo, taaki crash na ho)
                    ForecastWindow tabData;
                    if (_selectedTab == 0) {
                      tabData = windows.firstWhere(
                        (w) => w.window == 'This Weekend',
                        orElse: () => windows[0], // safe fallback
                      );
                    } else {
                      // _selectedTab == 1 (Rest of month / Next 30 Days)
                      tabData = windows.firstWhere(
                        (w) => w.window == 'Next 30 Days',
                        orElse: () => windows.length > 1
                            ? windows[1]
                            : windows[0], // safe fallback
                      );
                    }

                   final data = forecastTabDataFromWindow(tabData, _completedIds); // 🔧 CHANGED// ✅ ab sahi window pass ho raha hai

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _buildTabContent(
                          data,
                        ), // 🔧 variable name 'data' use kiya (pehle 'tabData' tha, naam clash na ho isliye)
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


StatusTone _toneFromSeverity(String severity) {
  switch (severity) {
    case 'red':
      return StatusTone.pressing;
    case 'amber':
    case 'below_average':
      return StatusTone.watch;
    case 'green':
    case 'above_average':
      return StatusTone.good;

    default:
      return StatusTone.steady;
  }
}

StatusTone _toneFromSectionSeverity(String severity) {
  switch (severity) {
    case 'above_average':
      return StatusTone.good;
    case 'below_average':
      return StatusTone.watch;
    default:
      return StatusTone.steady;
  }
}

int _confidenceFromLabel(String confidence) {
  switch (confidence.toLowerCase()) {
    case 'high':
      return 90;
    case 'medium':
      return 65;
    default:
      return 40;
  }
}

String _money(double value) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs().toStringAsFixed(0);
  final withCommas = abs.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '$sign\$$withCommas';
}

ForecastTabData forecastTabDataFromWindow(
  ForecastWindow window,
  Set<String> completedIds,
) {
  final worldScanFirst = window.worldScan.isNotEmpty
      ? window.worldScan.first
      : const WorldScanFlag(
          flag: '',
          horizon: '',
          dependsOn: '',
          actionYet: '',
          source: '',
        );
  final hasVolumeData =
      window.hero.volumeForecast != null &&
      window.hero.volumeUnit != null &&
      window.hero.volumeUnit!.isNotEmpty;
  return ForecastTabData(
    status: _toneFromSeverity(window.severity),
    dateRangeLabel: window.window.toUpperCase(),
    headline: window.hero.headline,
    expectedLabel: window.window.toUpperCase(),
    expectedValue: window.hero.expectedValue,
    normalValue: '',
    altValue: hasVolumeData
        ? '${window.hero.volumeForecast} ${window.hero.volumeUnit}'
        : null,
    altLabel: hasVolumeData ? window.hero.volumeUnit : null,
    deltaLabel: window.swingFactor.deltaText,
    deltaPositive: window.swingFactor.direction == 'up',
    confidencePercent: window.hero.confidencePct,
    confidenceLabel: '${window.hero.confidenceLabel.toUpperCase()} CONFIDENCE',
    confidenceBody: window.hero.anchor,
    swingFactorBody:
        '${window.swingFactor.reasoning} (${window.swingFactor.deltaText})',
    doThisTone: _toneFromSectionSeverity(
      window.sectionSummaries.doThis.severity,
    ),
    doThisSummary: window.sectionSummaries.doThis.summary,
    doThisIntro:
        'Each one pre-answered — the why, the deadline, the dollar logic.',
    doThisItems: window.actions
        .map(
          (a) => DoThisItem(
             id: a.id,      
            title: a.title,
            dateLabel: a.deadline,
            priority: a.priority.toUpperCase(),
            tag: a.tiedToDriver,
            whyBody: a.whyThisMuch,
            whyDollarLine: a.dollarLogic,
              completed: completedIds.contains(a.id),
          ),
        )
        .toList(),
    movingTone: _toneFromSectionSeverity(
      window.sectionSummaries.whatsMoving.severity,
    ),
    movingSummary: window.sectionSummaries.whatsMoving.summary,
    movingItems: window.drivers
        .map(
          (d) => ForceItem(
            title: d.name,
            dateLabel: d.window,
            deltaLabel: d.impactText,
            positive:
                d.severity == 'green' || d.impactText.trim().startsWith('+'),
            body: d.reasoning,
            confidencePercent: _confidenceFromLabel(d.confidence),
            sourceLabel: d.source,
          ),
        )
        .toList(),
    breakdownTone: _toneFromSectionSeverity(
      window.sectionSummaries.breakdown.severity,
    ),
    breakdownSummary: window.sectionSummaries.breakdown.summary,
    breakdown: BreakdownData(
      committed: _money(window.breakdown.committed),
      expectedLosses: _money(window.breakdown.expectedLosses),
      unbookedDemand: _money(window.breakdown.unbookedDemand),
      externalAdjustment: _money(window.breakdown.externalAdjustment),
    ),
    trackRecordTone: _toneFromSectionSeverity(
      window.sectionSummaries.trackRecord.severity,
    ),
    trackRecordSummary: window.sectionSummaries.trackRecord.summary,
    trackRecordBody: window.trackRecord.accuracyReceipt,
    trackRecordFooter: window.trackRecord.leanGuidance,
    worldScanTone: _toneFromSectionSeverity(
      window.sectionSummaries.worldScan.severity,
    ),
    worldScanCount: window.worldScan.isEmpty
        ? null
        : '${window.worldScan.length} watch',
    worldScan: WorldScanData(
      title: worldScanFirst.flag,
      dateLabel: worldScanFirst.horizon,
      body: worldScanFirst.dependsOn,
      doNow: worldScanFirst.actionYet.isEmpty
          ? null
          : 'Do now: ${worldScanFirst.actionYet}',
      sourceLabel: worldScanFirst.source,
    ),
  );
}

// class _SlicesPlaceholder extends StatelessWidget {
//   const _SlicesPlaceholder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.glassDark,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.glassBorder),
//       ),
//       child: Text(
//         '\$ / slices view is still being built.',
//         style: AppTextStyles.small,
//       ),
//     );
//   }
// }
