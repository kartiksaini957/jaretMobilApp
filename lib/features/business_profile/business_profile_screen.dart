import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import '../business_health/business_health_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import 'classification/classification_screen.dart';
import 'data/profile_question_flow_data.dart';
import 'data/profile_sections_data.dart';
import 'flow/question_flow_screen.dart';
import 'locations/locations_screen.dart';
import 'owner_notes/owner_notes_screen.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_insight_banner.dart';
import 'widgets/profile_sections_list.dart';
import 'widgets/understanding_meter_card.dart';

/// Business Profile hub: completion snapshot, an AI insight, quick links
/// into the classification/notes views, and the full section list. Every
/// section row opens the [QuestionFlowScreen] (currently showing the
/// Customers & Market questions as a placeholder) except "Business
/// Basics", which opens [LocationsScreen].
class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  bool _showInsight = true;

  static const _totalSections = 16;
  static int get _completeCount => profileSections
      .where((s) => s.status == SectionStatus.complete)
      .length;

  void _openCustomersMarketFlow() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const QuestionFlowScreen(flow: customersMarketFlow),
      ),
    );
  }

  void _openClassification() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ClassificationScreen()),
    );
  }

  void _openOwnerNotes() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OwnerNotesScreen()));
  }

  void _openLocations() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LocationsScreen()));
  }

  void _openSection(ProfileSectionData section) {
    if (section.title == 'Business Basics') {
      _openLocations();
    } else {
      _openCustomersMarketFlow();
    }
  }

  void _onDrawerItemSelected(int index) {
    if (index == 6) return; // Business Profile — already here.
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 6,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.headline,
                    children: [
                      TextSpan(text: '$_completeCount'),
                      TextSpan(
                        text: ' of $_totalSections sections complete',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.faintText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The more LightSignal knows, the sharper every read '
                  'gets — every agent sees this profile on every call.',
                  style: AppTextStyles.small,
                ),
                const SizedBox(height: 16),
                const UnderstandingMeterCard(
                  statusLabel: 'Building',
                  progress: 0.58,
                  caption:
                      'This moves as you tell us things we can actually '
                      'use — not by how many boxes you tick.',
                ),
                if (_showInsight) ...[
                  const SizedBox(height: 16),
                  ProfileInsightBanner(
                    eyebrow: 'BUSINESSES LIKE YOURS',
                    leadText: 'Slice shops like yours commonly find ',
                    highlight: '2–3 points of margin',
                    trailText:
                        ' hiding in vendor pricing. Finish your Operations '
                        "answers and we'll run the same check on your "
                        'cheese and flour costs.',
                    onDismiss: () => setState(() => _showInsight = false),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _openCustomersMarketFlow,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.glassLight,
                      side: const BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Continue — Customers & Market →',
                      style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ProfileInfoCard(
                  title: 'How LightSignal sees your business',
                  caption:
                      '12 classification dimensions from your profile and '
                      'data — correct anything we got wrong.',
                  pillLabel: 'REVIEW · 2 LOW',
                  pillColor: AppColors.warnDot,
                  onPillTap: _openClassification,
                ),
                const SizedBox(height: 16),
                ProfileInfoCard(
                  title: 'Tell LightSignal something',
                  caption:
                      "Owner notes — what you're seeing on the ground. "
                      '3 notes this quarter.',
                  pillLabel: '+ ADD A NOTE',
                  onPillTap: _openOwnerNotes,
                ),
                const SizedBox(height: 24),
                Text('PROFILE SECTIONS', style: AppTextStyles.eyebrow),
                const SizedBox(height: 10),
                ProfileSectionsList(
                  sections: profileSections,
                  onSectionTap: _openSection,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
