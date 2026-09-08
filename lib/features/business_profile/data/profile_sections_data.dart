import 'onboarding_sections_repository.dart';

/// Status of one Business Profile section on the hub's section list.
enum SectionStatus { complete, inProgress, notStarted }

/// One row in "PROFILE SECTIONS": display info plus which step of the
/// existing [BusinessProfileWizardScreen] it opens.
class ProfileSectionData {
  const ProfileSectionData({
    required this.number,
    required this.title,
    required this.status,
    this.progressLabel,
    required this.wizardSection,
    this.answeredCount = 0,
    this.totalQuestions = 0,
  });

  final int number;
  final String title;
  final SectionStatus status;

  /// e.g. "4 of 7 answered" — only set when [status] is [SectionStatus.inProgress].
  final String? progressLabel;

  /// Section index to open in [BusinessProfileWizardScreen].
  final int wizardSection;
  final int answeredCount;
  final int totalQuestions;

  String get statusLabel => switch (status) {
    SectionStatus.complete => 'Complete',
    SectionStatus.inProgress => progressLabel ?? 'In progress',
    SectionStatus.notStarted => 'Not started',
  };
}

/// Calculates how many questions in a section have answered values
int calculateSectionAnsweredCount(
  int sectionNumber,
  Map<String, dynamic>? sectionData,
  int totalQuestions,
) {
  if (sectionData == null || sectionData.isEmpty) return 0;

  // 1. If sectionData contains interactive keys (q_1_..., q_2_...)
  final qKeys = sectionData.keys.where((k) => k.startsWith('q_')).toList();
  if (qKeys.isNotEmpty) {
    int count = 0;
    for (final k in qKeys) {
      final val = sectionData[k];
      if (val != null) {
        if (val is String && val.trim().isNotEmpty) {
          count++;
        } else if (val is List && val.isNotEmpty) {
          count++;
        } else if (val is Map && val.isNotEmpty) {
          count++;
        } else if (val is num || val is bool) {
          count++;
        }
      }
    }
    return count > totalQuestions ? totalQuestions : count;
  }

  // 2. Count non-empty values in backend JSON map for this section
  int filledFields = 0;
  sectionData.forEach((key, val) {
    if (val != null) {
      if (val is String && val.trim().isNotEmpty) {
        filledFields++;
      } else if (val is List && val.isNotEmpty) {
        filledFields++;
      } else if (val is Map && val.isNotEmpty) {
        filledFields++;
      } else if (val is bool) {
        filledFields++;
      } else if (val is num && val != 0) {
        filledFields++;
      }
    }
  });

  return filledFields > totalQuestions ? totalQuestions : filledFields;
}

/// Dynamic profile sections builder based on current onboarding data
List<ProfileSectionData> getDynamicProfileSections([
  Map<String, dynamic>? onboardingData,
  int? sectionsComplete,
]) {
  final sections = <ProfileSectionData>[];

  final sectionConfigs = [
    (1, 'Business Basics', 7, 1, 'section_01_business_basics'),
    (2, 'Ownership & Key People', 4, 2, 'section_02_ownership_and_key_people'),
    (3, 'Industry & Model', 4, 3, 'section_03_industry_and_model'),
    (4, 'Operations', 10, 5, 'section_04_operations'),
    (5, 'Financial Overview', 5, 9, 'section_05_financial_overview'),
    (6, 'Assets & Equipment', 5, 13, 'section_06_assets_and_equipment'),
    (7, 'Customers & Market', 15, 11, 'section_07_customers_and_market'),
    (8, 'Risk & Exposure', 6, 14, 'section_08_risk_and_exposure'),
    (9, 'Capacity & Constraints', 5, 6, 'section_09_capacity_and_constraints'),
    (10, 'Opportunity Readiness', 14, 4, 'section_10_opportunity_readiness'),
    (11, 'Strategic Goals', 4, 16, 'section_11_strategic_goals'),
    (12, 'Pricing & Revenue', 4, 10, 'section_12_pricing_and_revenue'),
    (13, 'Hiring & Team Structure', 4, 8, 'section_13_hiring_and_team_structure'),
    (14, 'Sales & Marketing', 5, 7, 'section_14_sales_and_marketing'),
    (15, 'Owner Goals & Preferences', 3, 15, 'section_15_owner_goals_and_preferences'),
  ];

  final allData = onboardingData ?? OnboardingSectionsRepository().allSections;

  for (final config in sectionConfigs) {
    final secNum = config.$1;
    final title = config.$2;
    final totalQ = config.$3;
    final wizardSec = config.$4;
    final key = config.$5;

    final secData = (allData[key] as Map<String, dynamic>?) ??
        OnboardingSectionsRepository().getSectionData(secNum);

    final answered = calculateSectionAnsweredCount(secNum, secData, totalQ);

    final SectionStatus status;
    final String? progressLabel;

    if (answered == 0) {
      status = SectionStatus.notStarted;
      progressLabel = null;
    } else if (answered >= totalQ) {
      status = SectionStatus.complete;
      progressLabel = null;
    } else {
      status = SectionStatus.inProgress;
      progressLabel = '$answered of $totalQ answered';
    }

    sections.add(
      ProfileSectionData(
        number: secNum,
        title: title,
        status: status,
        progressLabel: progressLabel,
        wizardSection: wizardSec,
        answeredCount: answered,
        totalQuestions: totalQ,
      ),
    );
  }

  // Section 16: Uploads & Docs
  final isUploadsComplete = sectionsComplete != null && sectionsComplete >= 16;
  sections.add(
    ProfileSectionData(
      number: 16,
      title: 'Uploads & Docs',
      status: isUploadsComplete
          ? SectionStatus.complete
          : SectionStatus.notStarted,
      wizardSection: 17,
      answeredCount: isUploadsComplete ? 1 : 0,
      totalQuestions: 1,
    ),
  );

  return sections;
}

/// Fallback default list
final profileSections = getDynamicProfileSections();
