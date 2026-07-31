import 'package:flutter/material.dart';

import '../../widgets/customToast.dart';
import 'theme/business_profile_colors.dart';
import 'widgets/uploads_documents_section.dart';
import 'widgets/wizard_sections.dart';
import 'widgets/wizard_shell.dart';

class _WizardStep {
  const _WizardStep({
    required this.section,
    required this.progressLabel,
    required this.cardTitle,
    required this.builder,
  });

  final int section;
  final String progressLabel;
  final String cardTitle;
  final WidgetBuilder builder;
}

/// Business Profile setup wizard: one long form per section, stepped
/// through with Back/Save & Next. Reached from the Business Profile hub
/// by tapping "Continue" or a specific section row.
class BusinessProfileWizardScreen extends StatefulWidget {
  const BusinessProfileWizardScreen({super.key, this.initialSection = 1});

  /// Section number (1–17) to open on. Defaults to the first section.
  final int initialSection;

  @override
  State<BusinessProfileWizardScreen> createState() =>
      _BusinessProfileWizardScreenState();
}

class _BusinessProfileWizardScreenState
    extends State<BusinessProfileWizardScreen> {
  static const totalSections = 17;

  static final List<_WizardStep> _steps = [
    _WizardStep(
      section: 1,
      progressLabel: 'Business Basics',
      cardTitle: 'Business Basics',
      builder: (_) => const BusinessBasicsSection(),
    ),
    _WizardStep(
      section: 2,
      progressLabel: 'Ownership & Key People',
      cardTitle: 'Ownership & Key People',
      builder: (_) => const OwnershipKeyPeopleSection(),
    ),
    _WizardStep(
      section: 3,
      progressLabel: 'Industry & What You Do',
      cardTitle: 'Business Description',
      builder: (_) => const BusinessDescriptionSection(),
    ),
    _WizardStep(
      section: 4,
      progressLabel: 'Service Area & Opportunity Search Preferences',
      cardTitle: 'Service Area & Opportunity Search Preferences',
      builder: (_) => const ServiceAreaPreferencesSection(),
    ),
    _WizardStep(
      section: 5,
      progressLabel: 'Operations Snapshot',
      cardTitle: 'Operations & Team',
      builder: (_) => const OperationsTeamSection(),
    ),
    _WizardStep(
      section: 6,
      progressLabel: 'Capacity & Constraints',
      cardTitle: 'Capacity & Constraints',
      builder: (_) => const CapacityConstraintsSection(),
    ),
    _WizardStep(
      section: 7,
      progressLabel: 'Sales & Marketing',
      cardTitle: 'Sales & Marketing',
      builder: (_) => const SalesMarketingSection(),
    ),
    _WizardStep(
      section: 8,
      progressLabel: 'Hiring & Team Structure',
      cardTitle: 'Hiring & Team Structure',
      builder: (_) => const HiringTeamStructureSection(),
    ),
    _WizardStep(
      section: 9,
      progressLabel: 'Financial Systems',
      cardTitle: 'Financial Systems',
      builder: (_) => const FinancialSystemsSection(),
    ),
    _WizardStep(
      section: 10,
      progressLabel: 'Pricing & Revenue Model',
      cardTitle: 'Pricing & Revenue Model',
      builder: (_) => const PricingRevenueModelSection(),
    ),
    _WizardStep(
      section: 11,
      progressLabel: 'Customers & Market',
      cardTitle: 'Customers & Market',
      builder: (_) => const CustomersMarketSection(),
    ),
    _WizardStep(
      section: 12,
      progressLabel: 'Vendors & Inputs',
      cardTitle: 'Vendors & Inputs',
      builder: (_) => const VendorsInputsSection(),
    ),
    _WizardStep(
      section: 13,
      progressLabel: 'Assets & Equipment',
      cardTitle: 'Assets & Equipment',
      builder: (_) => const AssetsEquipmentSection(),
    ),
    _WizardStep(
      section: 14,
      progressLabel: 'Risk, Insurance & Debt',
      cardTitle: 'Risk, Insurance & Debt',
      builder: (_) => const RiskInsuranceDebtSection(),
    ),
    _WizardStep(
      section: 15,
      progressLabel: 'Permits & Compliance',
      cardTitle: 'Permits & Compliance',
      builder: (_) => const PermitsComplianceSection(),
    ),
    _WizardStep(
      section: 16,
      progressLabel: 'Strategic Goals & Preferences',
      cardTitle: 'Strategic Goals & Preferences',
      builder: (_) => const StrategicGoalsSection(),
    ),
    _WizardStep(
      section: 17,
      progressLabel: 'Uploads & Documents',
      cardTitle: 'Uploads & Documents',
      builder: (_) => const UploadsDocumentsSection(),
    ),
  ];

  late int _stepIndex = _steps
      .indexWhere((step) => step.section == widget.initialSection)
      .clamp(0, _steps.length - 1)
      .toInt();

  void _goNext() {
    if (_stepIndex < _steps.length - 1) {
      setState(() => _stepIndex++);
    } else {
      CustomToast.showSuccess(context, 'Business profile completed.');
    }
  }

  void _goBack() {
    if (_stepIndex > 0) setState(() => _stepIndex--);
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_stepIndex];
    final isLast = _stepIndex == _steps.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              BusinessProfileColors.bgTop,
              BusinessProfileColors.bgBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  children: [
                    WizardProgressBar(
                      current: step.section,
                      total: totalSections,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Section ${step.section} of $totalSections: '
                      '${step.progressLabel}',
                      style: const TextStyle(
                        color: BusinessProfileColors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: WizardSectionCard(
                    title: step.cardTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        step.builder(context),
                        const SizedBox(height: 24),
                        WizardFooter(
                          onBack: _stepIndex == 0 ? null : _goBack,
                          onNext: _goNext,
                          onSkip: isLast ? null : _goNext,
                          nextLabel: isLast
                              ? 'Complete Profile'
                              : 'Save & Next',
                        ),
                      ],
                    ),
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
