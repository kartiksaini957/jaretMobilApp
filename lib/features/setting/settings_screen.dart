import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/cenario_lab_screen.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/gradient_background.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../business_health/business_health_screen.dart';
import '../business_profile/business_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
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
import 'widgets/notification_bell.dart';
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

  /// `.wrap { max-width: 1080px }`
  static const double _contentMaxWidth = 1080;

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
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const OpportunitiesScreen()));
      return;
    }
    if (index == 5) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScenariooLabScreen()));
      return;
    }
    if (index == 6) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BusinessProfileScreen()));
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
      // The shared aurora field, so Settings reads like every other tab.
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              // `.wrap { max-width: 1080px }` — keeps the panels readable
              // instead of stretching them across an iPad.
              constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
              child: Column(
                children: [
                  _SettingsHeader(
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SettingsTabBar(
                            tabs: _tabs,
                            selectedIndex: selectedIndex,
                            onChanged: (i) => ref
                                .read(settingsTabIndexProvider.notifier)
                                .state = i,
                          ),
                          const SizedBox(height: 22),
                          _tabBuilders[selectedIndex],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu, color: SettingsColors.white),
          ),
          // `.crumb` — "LightSignal / **Settings**".
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'LightSignal / ',
                    style: AppTextStyles.body.copyWith(
                      color: SettingsColors.soft,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: 'Settings',
                    style: AppTextStyles.body.copyWith(
                      color: SettingsColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const NotificationBell(),
        ],
      ),
    );
  }
}
