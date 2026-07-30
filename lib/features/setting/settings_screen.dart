import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customToast.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../business_health/business_health_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import 'provider/settings_tab_provider.dart';
import 'tabs/ai_corrections_tab.dart';
import 'tabs/backup_tab.dart';
import 'tabs/billing_tab.dart';
import 'tabs/data_privacy_tab.dart';
import 'tabs/general_tab.dart';
import 'tabs/integrations_tab.dart';
import 'tabs/notifications_tab.dart';
import 'tabs/security_team_tab.dart';
import 'theme/settings_colors.dart';
import 'widgets/settings_tab_bar.dart';

/// Settings — General / Integrations / Data & Privacy / Notifications /
/// Security & Team / AI & Corrections / Billing / Backup, selected via a
/// pill tab bar with a single content card below.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _tabs = [
    SettingsTab('General'),
    SettingsTab('Integrations'),
    SettingsTab('Data & Privacy'),
    SettingsTab('Notifications'),
    SettingsTab('Security & Team'),
    SettingsTab('AI & Corrections'),
    SettingsTab('Billing'),
    SettingsTab('Backup'),
  ];

  static const _tabBuilders = [
    GeneralTab(),
    IntegrationsTab(),
    DataPrivacyTab(),
    NotificationsTab(),
    SecurityTeamTab(),
    AiCorrectionsTab(),
    BillingTab(),
    BackupTab(),
  ];

  void _onDrawerItemSelected(int index) {
    if (index == 7) return; // Settings — already here.
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const DemandForecastScreen()));
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FinancialOverviewScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BusinessHealthScreen()));
      return;
    }
    if (index == 5) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScenarioLabScreen()));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(initialDrawerIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(settingsTabIndexProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppNavDrawer(
        selectedIndex: 7,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.baseDeep,
              AppColors.baseMid,
              AppColors.baseLight,
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _SettingsHeader(
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsTabBar(
                        tabs: _tabs,
                        selectedIndex: selectedIndex,
                        onChanged: (i) =>
                            ref.read(settingsTabIndexProvider.notifier).state =
                                i,
                      ),
                      const SizedBox(height: 20),
                      _tabBuilders[selectedIndex],
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
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu, color: SettingsColors.white),
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'LightSignal ',
                  style: TextStyle(
                    color: SettingsColors.faintText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '/ Settings',
                  style: TextStyle(
                    color: SettingsColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => CustomToast.showInfo(context, 'Notifications'),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  color: SettingsColors.white,
                ),
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: const BoxDecoration(
                      color: SettingsColors.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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
