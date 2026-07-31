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
  });

  final int number;
  final String title;
  final SectionStatus status;

  /// e.g. "4 of 7 answered" — only set when [status] is [SectionStatus.inProgress].
  final String? progressLabel;

  /// Section index to open in [BusinessProfileWizardScreen].
  final int wizardSection;

  String get statusLabel => switch (status) {
    SectionStatus.complete => 'Complete',
    SectionStatus.inProgress => progressLabel ?? 'In progress',
    SectionStatus.notStarted => 'Not started',
  };
}

const profileSections = [
  ProfileSectionData(
    number: 1,
    title: 'Business Basics',
    status: SectionStatus.complete,
    wizardSection: 1,
  ),
  ProfileSectionData(
    number: 2,
    title: 'Ownership & Key People',
    status: SectionStatus.complete,
    wizardSection: 2,
  ),
  ProfileSectionData(
    number: 3,
    title: 'Industry & Model',
    status: SectionStatus.complete,
    wizardSection: 3,
  ),
  ProfileSectionData(
    number: 4,
    title: 'Operations',
    status: SectionStatus.inProgress,
    progressLabel: '4 of 7 answered',
    wizardSection: 5,
  ),
  ProfileSectionData(
    number: 5,
    title: 'Financial Overview',
    status: SectionStatus.complete,
    wizardSection: 9,
  ),
  ProfileSectionData(
    number: 6,
    title: 'Assets & Equipment',
    status: SectionStatus.notStarted,
    wizardSection: 13,
  ),
  ProfileSectionData(
    number: 7,
    title: 'Customers & Market',
    status: SectionStatus.inProgress,
    progressLabel: '2 of 7 answered',
    wizardSection: 11,
  ),
  ProfileSectionData(
    number: 8,
    title: 'Risk & Exposure',
    status: SectionStatus.notStarted,
    wizardSection: 14,
  ),
  ProfileSectionData(
    number: 9,
    title: 'Capacity & Constraints',
    status: SectionStatus.complete,
    wizardSection: 6,
  ),
  ProfileSectionData(
    number: 10,
    title: 'Opportunity Readiness',
    status: SectionStatus.inProgress,
    progressLabel: '6 of 14 answered',
    wizardSection: 4,
  ),
  ProfileSectionData(
    number: 11,
    title: 'Strategic Goals',
    status: SectionStatus.complete,
    wizardSection: 16,
  ),
  ProfileSectionData(
    number: 12,
    title: 'Pricing & Revenue',
    status: SectionStatus.complete,
    wizardSection: 10,
  ),
  ProfileSectionData(
    number: 13,
    title: 'Hiring & Team Structure',
    status: SectionStatus.notStarted,
    wizardSection: 8,
  ),
  ProfileSectionData(
    number: 14,
    title: 'Sales & Marketing',
    status: SectionStatus.inProgress,
    progressLabel: '1 of 6 answered',
    wizardSection: 7,
  ),
  ProfileSectionData(
    number: 15,
    title: 'Owner Goals & Preferences',
    status: SectionStatus.complete,
    wizardSection: 15,
  ),
  ProfileSectionData(
    number: 16,
    title: 'Uploads & Docs',
    status: SectionStatus.notStarted,
    wizardSection: 17,
  ),
];
