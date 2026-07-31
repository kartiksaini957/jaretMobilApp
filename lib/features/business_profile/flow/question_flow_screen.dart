import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/gradient_background.dart';
import '../data/profile_question_flow_data.dart';
import 'widgets/chip_select_input.dart';
import 'widgets/flow_footer_buttons.dart';
import 'widgets/flow_header.dart';
import 'widgets/flow_progress_dots.dart';
import 'widgets/step_slider_input.dart';

/// One-question-at-a-time flow for a single Business Profile section: an
/// intro card (title, description, progress, Later/Continue) followed by
/// one card per question (chips or a step slider), Skip/Continue footer,
/// and "Save & finish later" on the last question.
class QuestionFlowScreen extends StatefulWidget {
  const QuestionFlowScreen({super.key, required this.flow});

  final ProfileSectionFlow flow;

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  static const _fullWidthOptions = ['Fairly consistent year-round'];

  bool _onIntro = true;
  int _questionIndex = 0;
  late int _answeredCount = widget.flow.answeredBefore;

  final Map<int, Set<String>> _multiSelections = {};
  final Map<int, int> _sliderSelections = {};

  bool get _isLastQuestion =>
      _questionIndex == widget.flow.questions.length - 1;

  void _goToIntro() => setState(() => _onIntro = true);

  void _startQuestions() => setState(() {
    _onIntro = false;
    _questionIndex = 0;
  });

  void _goBackFromQuestion() {
    if (_questionIndex == 0) {
      _goToIntro();
    } else {
      setState(() => _questionIndex--);
    }
  }

  void _advanceOrFinish({required bool wasAnswered}) {
    if (wasAnswered) _answeredCount++;
    if (_isLastQuestion) {
      CustomToast.showSuccess(context, 'Saved. Come back anytime.');
      Navigator.of(context).pop();
    } else {
      setState(() => _questionIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlowHeader(
                  label: _onIntro
                      ? 'SECTION ${widget.flow.sectionNumber}'
                      : widget.flow.sectionTitle.toUpperCase(),
                  onBack: _onIntro
                      ? () => Navigator.of(context).pop()
                      : _goBackFromQuestion,
                ),
                const SizedBox(height: 14),
                _onIntro ? _buildIntroCard() : _buildQuestionCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.flow.sectionTitle,
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(widget.flow.sectionDescription, style: AppTextStyles.small),
          const SizedBox(height: 14),
          FlowProgressDots(
            total: widget.flow.totalQuestions,
            answered: _answeredCount,
          ),
          const SizedBox(height: 18),
          FlowFooterButtons(
            secondaryLabel: 'Later',
            onSecondary: () => Navigator.of(context).pop(),
            primaryLabel: 'Continue →',
            onPrimary: _startQuestions,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = widget.flow.questions[_questionIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title,
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 6),
          Text(question.subtitle, style: AppTextStyles.small),
          const SizedBox(height: 16),
          if (question.type == QuestionInputType.slider)
            StepSliderInput(
              labels: question.options,
              selectedIndex: _sliderSelections[_questionIndex],
              onSelect: (i) =>
                  setState(() => _sliderSelections[_questionIndex] = i),
            )
          else
            ChipSelectInput(
              options: question.options,
              fullWidthOptions: _fullWidthOptions,
              selected: _multiSelections[_questionIndex] ?? const {},
              onToggle: (option) => setState(() {
                final set = _multiSelections.putIfAbsent(
                  _questionIndex,
                  () => {},
                );
                set.contains(option) ? set.remove(option) : set.add(option);
              }),
            ),
          const SizedBox(height: 18),
          FlowFooterButtons(
            secondaryLabel: 'Skip',
            onSecondary: () => _advanceOrFinish(wasAnswered: false),
            primaryLabel: _isLastQuestion ? 'Save & finish later →' : 'Continue →',
            onPrimary: () => _advanceOrFinish(wasAnswered: true),
          ),
        ],
      ),
    );
  }
}
