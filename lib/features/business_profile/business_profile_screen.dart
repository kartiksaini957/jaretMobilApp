import 'package:flutter/material.dart';
import '../../core/api_services.dart';
import '../../theme/app_theme.dart';
import '../../utils/pref_utils.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import 'data/onboarding_sections_repository.dart';
import 'data/profile_question_flow_data.dart';
import 'data/profile_sections_data.dart';
import 'flow/question_flow_screen.dart';
import 'locations/locations_screen.dart';
import 'model/business_profile_onboarding_model.dart';
import 'model/business_profile_richness_model.dart';
import 'owner_notes/owner_notes_screen.dart';
import 'uploads/uploads_docs_screen.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_insight_banner.dart';
import 'widgets/profile_sections_list.dart';
import 'widgets/understanding_meter_card.dart';
import 'dart:math' show pi;
import '../../widgets/app_nav_destinations.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  bool _showInsight = true;
  BusinessProfileRichness _richness = const BusinessProfileRichness(
    score: 0.00,
    band: 'Loading...',
    everReachedSharp: true,
    sectionsComplete: 0,
    totalSections: 16,
  );
  BusinessProfileOnboardingData _onboardingData =
      BusinessProfileOnboardingData.fallbackData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllProfileData();
  }

  Future<void> _loadAllProfileData() async {
    setState(() => _isLoading = true);
    await Future.wait([_fetchRichness(), _fetchOnboardingData()]);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchOnboardingData() async {
    try {
      final token = await PrefUtils.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final res = await ApiService().getBusinessProfileOnboarding(
          accessToken: token,
        );
        if (res.rawOnboardingData.isNotEmpty) {
          OnboardingSectionsRepository().loadFromApiResponse(
            res.rawOnboardingData,
          );
        }
        if (mounted) {
          setState(() {
            _onboardingData = res;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching onboarding data: $e');
    }
  }

  Future<void> _fetchRichness() async {
    try {
      final token = await PrefUtils.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final res = await ApiService().getBusinessProfileRichness(
          accessToken: token,
        );
        if (mounted) {
          setState(() {
            _richness = res;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching business profile richness: $e');
    }
  }

  ProfileSectionData? _getNextIncompleteSection() {
    final sections = getDynamicProfileSections(
      _onboardingData.rawOnboardingData,
      _richness.sectionsComplete,
    );
    for (final section in sections) {
      if (section.status != SectionStatus.complete) {
        return section;
      }
    }
    return null;
  }

  void _openNextIncompleteSection() {
    final nextSection = _getNextIncompleteSection();
    if (nextSection != null) {
      _openSection(nextSection);
    } else {
      final sections = getDynamicProfileSections(
        _onboardingData.rawOnboardingData,
        _richness.sectionsComplete,
      );
      if (sections.isNotEmpty) {
        _openSection(sections.first);
      }
    }
  }

  void _openCustomersMarketFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: customersMarketFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }



  void _openOwnerNotes() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const OwnerNotesScreen()))
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openLocations() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LocationsScreen()))
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openOwnershipKeyPeopleFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: ownershipKeyPeopleFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openIndustryModelFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: industryModelFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openOperationsFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: operationsFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openFinancialOverviewFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: financialOverviewFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openAssetsEquipmentFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: assetsEquipmentFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openRiskExposureFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: riskExposureFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openCapacityConstraintsFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: capacityConstraintsFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openOpportunityReadinessFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: opportunityReadinessFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openStrategicGoalsFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: strategicGoalsFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openPricingRevenueFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: pricingRevenueFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openHiringTeamStructureFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: hiringTeamStructureFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openSalesMarketingFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: salesMarketingFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openOwnerGoalsPreferencesFlow() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: ownerGoalsPreferencesFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openUploadsDocsScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const UploadsDocsScreen()))
        .then((_) {
          if (mounted) _loadAllProfileData();
        });
  }

  void _openSection(ProfileSectionData section) {
    if (section.title == 'Business Basics') {
      _openLocations();
    } else if (section.title == 'Ownership & Key People') {
      _openOwnershipKeyPeopleFlow();
    } else if (section.title == 'Industry & Model') {
      _openIndustryModelFlow();
    } else if (section.title == 'Operations') {
      _openOperationsFlow();
    } else if (section.title == 'Financial Overview') {
      _openFinancialOverviewFlow();
    } else if (section.title == 'Assets & Equipment') {
      _openAssetsEquipmentFlow();
    } else if (section.title == 'Customers & Market') {
      _openCustomersMarketFlow();
    } else if (section.title == 'Risk & Exposure') {
      _openRiskExposureFlow();
    } else if (section.title == 'Capacity & Constraints') {
      _openCapacityConstraintsFlow();
    } else if (section.title == 'Opportunity Readiness') {
      _openOpportunityReadinessFlow();
    } else if (section.title == 'Strategic Goals') {
      _openStrategicGoalsFlow();
    } else if (section.title == 'Pricing & Revenue') {
      _openPricingRevenueFlow();
    } else if (section.title == 'Hiring & Team Structure') {
      _openHiringTeamStructureFlow();
    } else if (section.title == 'Sales & Marketing') {
      _openSalesMarketingFlow();
    } else if (section.title == 'Owner Goals & Preferences') {
      _openOwnerGoalsPreferencesFlow();
    } else if (section.title == 'Uploads & Docs') {
      _openUploadsDocsScreen();
    } else {
      _openCustomersMarketFlow();
    }
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.businessProfile,
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
          child: RefreshIndicator(
            onRefresh: _fetchRichness,
            color: AppColors.accent,
            backgroundColor: AppColors.glassDark,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: LinearProgressIndicator(
                          minHeight: 2.5,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(95, 224, 255, 0.16),
                          Color.fromRGBO(95, 224, 255, 0.06),
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 20, 40, 0.50),
                          blurRadius: 55,
                          spreadRadius: -22,
                          offset: Offset(0, 22),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.headline,
                            children: [
                              TextSpan(
                                text: '${_richness.sectionsComplete}',
                                style: AppTextStyles.headline.copyWith(
                                  color: Colors.white,
                                  fontSize: 38,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' of ${_richness.totalSections} sections complete',
                                style: AppTextStyles.headline.copyWith(
                                  color: AppColors.faintText,
                                  fontSize: 16,
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
                        UnderstandingMeterCard(
                          statusLabel: _richness.band,
                          progress: _richness.score,
                          caption:
                              'This moves as you tell us things we can actually '
                              'use — not by how many boxes you tick.',
                        ),
                        if (_showInsight) ...[
                          const SizedBox(height: 16),
                          ProfileInsightBanner(
                            eyebrow: 'BUSINESSES LIKE YOURS',
                            leadText:
                                '${_onboardingData.businessName} like yours commonly find ',
                            highlight: '2–3 points of margin',
                            trailText:
                                ' hiding in food ingredient & commissary costs. Finish your Operations '
                                "answers and we'll run the same check on your "
                                'supplies and prep expenses.',
                            onDismiss: () =>
                                setState(() => _showInsight = false),
                          ),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  transform: const GradientRotation(
                                    160 * pi / 180,
                                  ),
                                  colors: const [
                                    Color(0xFF7FE3FF),
                                    Color(0xFF3FBFE0),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(5, 197, 250, 0.60),
                                    blurRadius: 26,
                                    spreadRadius: -12,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _openNextIncompleteSection,
                                child: Center(
                                  child: Text(
                                    _getNextIncompleteSection() != null
                                        ? 'Continue — ${_getNextIncompleteSection()!.title} →'
                                        : 'Review Profile →',
                                    style: AppTextStyles.body.copyWith(
                                      color: const Color(0xFF04303F),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ProfileInfoCard(
                  //   title: 'Your locations',
                  //   caption:
                  //       '${_onboardingData.locations.length} location · ${_onboardingData.locations.first.name} (${_onboardingData.locations.first.fullAddress})',
                  //   pillLabel: 'MANAGE · ACTIVE',
                  //   onPillTap: _openLocations,
                  // ),
                  // const SizedBox(height: 16),
                  // ProfileInfoCard(
                  //   title: 'How LightSignal sees your business',
                  //   caption:
                  //       '${_onboardingData.industryType} · ${_onboardingData.subIndustryTags.join(', ')} · NAICS ${_onboardingData.naicsCode} · Stage: ${_onboardingData.growthStage.toUpperCase()}',
                  //   pillLabel: 'REVIEW · 2 LOW',
                  //   onPillTap: _openClassification,
                  // ),
                  // const SizedBox(height: 16),
                  ProfileInfoCard(
                    title: 'Tell LightSignal something',
                    caption: _onboardingData.ownerObservations.isNotEmpty
                        ? 'Owner observation: "${_onboardingData.ownerObservations.first.text}"'
                        : "Owner notes — what you're seeing on the ground.",
                    pillLabel: '+ ADD A NOTE',
                    onPillTap: _openOwnerNotes,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PROFILE SECTIONS',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: const Color(0xFFA7DCF0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileSectionsList(
                    sections: getDynamicProfileSections(
                      _onboardingData.rawOnboardingData,
                      _richness.sectionsComplete,
                    ),
                    onSectionTap: _openSection,
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
