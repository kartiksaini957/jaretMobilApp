/// How a [ProfileQuestion] should be answered.
enum QuestionInputType { multiSelect, slider }

/// One question inside a [ProfileSectionFlow].
class ProfileQuestion {
  const ProfileQuestion({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.options,
  });

  final String title;
  final String subtitle;
  final QuestionInputType type;
  final List<String> options;
}

/// A section's one-question-at-a-time flow: the intro card copy plus the
/// questions themselves.
class ProfileSectionFlow {
  const ProfileSectionFlow({
    required this.sectionNumber,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.totalQuestions,
    required this.answeredBefore,
    required this.questions,
  });

  final int sectionNumber;
  final String sectionTitle;
  final String sectionDescription;

  /// Total questions in the full section (may exceed [questions].length —
  /// only the questions with authored content are interactive so far).
  final int totalQuestions;
  final int answeredBefore;
  final List<ProfileQuestion> questions;
}

const customersMarketFlow = ProfileSectionFlow(
  sectionNumber: 7,
  sectionTitle: 'Customers & Market',
  sectionDescription:
      'Who buys from you, where they come from, and how demand moves. '
      'Seven quick questions — skip anything; you can come back anytime.',
  totalQuestions: 7,
  answeredBefore: 2,
  questions: [
    ProfileQuestion(
      title: 'How far do your customers come from?',
      subtitle:
          'Roughly — this shapes which competitors, events, and '
          'opportunities matter for you.',
      type: QuestionInputType.slider,
      options: ['My neighborhood', 'Across the metro', 'Regional / beyond'],
    ),
    ProfileQuestion(
      title: 'When is business strongest?',
      subtitle:
          'Pick the seasons that spike — or tell us it holds steady '
          'year-round.',
      type: QuestionInputType.multiSelect,
      options: [
        'Spring',
        'Summer',
        'Fall',
        'Winter',
        'Fairly consistent year-round',
      ],
    ),
    ProfileQuestion(
      title: 'Where do most of your customers come from?',
      subtitle:
          'Your best guess is fine — walk-by, word of mouth, social, '
          'search, repeat regulars.',
      type: QuestionInputType.multiSelect,
      options: [
        'Walk-by / drive-by',
        'Word of mouth',
        'Social media',
        'Search / maps',
        'Repeat regulars',
      ],
    ),
  ],
);
