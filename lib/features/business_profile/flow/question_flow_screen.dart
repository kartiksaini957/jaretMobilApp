import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_nav_destinations.dart';
import '../../../widgets/app_nav_drawer.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/gradient_background.dart';
import '../data/onboarding_sections_repository.dart';
import '../data/profile_question_flow_data.dart';
import 'widgets/chip_select_input.dart';
import 'widgets/dropdown_select_input.dart';
import 'widgets/flow_footer_buttons.dart';
import 'widgets/flow_header.dart';
import 'widgets/step_slider_input.dart';
import 'widgets/text_question_input.dart';

class QuestionFlowScreen extends StatefulWidget {
  const QuestionFlowScreen({
    super.key,
    required this.flow,
    this.initialIntro = true,
  });

  final ProfileSectionFlow flow;
  final bool initialIntro;

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  static const _fullWidthOptions = ['Fairly consistent year-round'];

  late bool _onIntro = widget.initialIntro;
  int _questionIndex = 0;

  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, String> _selectSelections = {};
  final Map<int, Set<String>> _multiSelections = {};
  final Map<int, int> _sliderSelections = {};

  bool get _isLastQuestion =>
      _questionIndex == widget.flow.questions.length - 1;

  @override
  void initState() {
    super.initState();
    final savedData =
        OnboardingSectionsRepository().getSectionData(
          widget.flow.sectionNumber,
        ) ??
        {};
    final savedValues = savedData.values.toList();

    for (var i = 0; i < widget.flow.questions.length; i++) {
      final q = widget.flow.questions[i];
      dynamic val;
      if (q.apiKey != null && savedData.containsKey(q.apiKey)) {
        val = savedData[q.apiKey];
      } else {
        final generatedKey =
            'q_${i + 1}_${q.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '')}';
        if (savedData.containsKey(generatedKey)) {
          val = savedData[generatedKey];
        } else if (i < savedValues.length) {
          val = savedValues[i];
        }
      }

      if (q.type == QuestionInputType.text) {
        final initialText = (val != null ? val.toString() : (q.initialValue ?? ''));
        _textControllers[i] = TextEditingController(text: initialText);
      } else if (q.type == QuestionInputType.select) {
        if (val != null && val is String && val.isNotEmpty) {
          _selectSelections[i] = val;
        } else if (q.initialValue != null) {
          _selectSelections[i] = q.initialValue!;
        }
      } else if (q.type == QuestionInputType.multiSelect) {
        if (val != null) {
          if (val is List) {
            _multiSelections[i] = val.map((e) => e.toString()).toSet();
          } else if (val is String && val.isNotEmpty) {
            _multiSelections[i] = {val};
          }
        }
      } else if (q.type == QuestionInputType.slider) {
        if (val != null && val is String) {
          final idx = q.options.indexOf(val);
          if (idx != -1) _sliderSelections[i] = idx;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _goToIntro() => setState(() => _onIntro = true);

  void _startQuestions() => setState(() {
    _onIntro = false;
    _questionIndex = 0;
  });

  void _goBackFromQuestion() {
    final answers = _collectCurrentSectionAnswers();
    OnboardingSectionsRepository().updateSectionData(
      widget.flow.sectionNumber,
      answers,
    );

    if (_questionIndex == 0) {
      OnboardingSectionsRepository().syncAllToApi();
      if (!widget.initialIntro) {
        Navigator.of(context).pop();
      } else {
        _goToIntro();
      }
    } else {
      setState(() => _questionIndex--);
    }
  }

  Map<String, dynamic> _collectCurrentSectionAnswers() {
    final Map<String, dynamic> answers = {};
    for (var i = 0; i < widget.flow.questions.length; i++) {
      final q = widget.flow.questions[i];
      final key =
          q.apiKey ??
          'q_${i + 1}_${q.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '')}';
      if (q.type == QuestionInputType.text) {
        answers[key] = _textControllers[i]?.text.trim() ?? '';
      } else if (q.type == QuestionInputType.select) {
        answers[key] = _selectSelections[i] ?? '';
      } else if (q.type == QuestionInputType.slider) {
        final selectedIdx = _sliderSelections[i];
        if (selectedIdx != null && selectedIdx < q.options.length) {
          answers[key] = q.options[selectedIdx];
        }
      } else {
        answers[key] = _multiSelections[i]?.toList() ?? [];
      }
    }
    return answers;
  }

  bool _isSaving = false;

  Future<void> _advanceOrFinish({required bool wasAnswered}) async {
    if (_isSaving) return;
    final answers = _collectCurrentSectionAnswers();
    OnboardingSectionsRepository().updateSectionData(
      widget.flow.sectionNumber,
      answers,
    );

    if (_isLastQuestion) {
      setState(() => _isSaving = true);
      final ok = await OnboardingSectionsRepository().saveSectionAndSync(
        widget.flow.sectionNumber,
        answers,
      );
      if (mounted) {
        setState(() => _isSaving = false);
        if (ok) {
          CustomToast.showSuccess(
            context,
            'Section ${widget.flow.sectionNumber} saved successfully.',
          );
        } else {
          CustomToast.showSuccess(
            context,
            'Section ${widget.flow.sectionNumber} saved locally.',
          );
        }
        Navigator.of(context).pop();
      }
    } else {
      setState(() => _questionIndex++);
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
    final headerLabel = _onIntro
        ? 'SECTION ${widget.flow.sectionNumber}'
        : 'BUSINESS PROFILE · SECTION ${widget.flow.sectionNumber}';

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
                FlowHeader(
                  label: headerLabel,
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
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
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
        border: Border.all(
          color: const Color.fromRGBO(127, 227, 255, 0.4),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 20, 40, 0.4),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.flow.sectionTitle,
            style: AppTextStyles.headline.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.flow.sectionDescription,
            style: AppTextStyles.body.copyWith(
              color: const Color(0xFFD4EFFC),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(),
          const SizedBox(height: 24),
          FlowFooterButtons(
            secondaryLabel: 'Later',
            onSecondary: () => Navigator.of(context).pop(),
            primaryLabel: 'Start section →',
            onPrimary: _startQuestions,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(8, 32, 48, 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(127, 227, 255, 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.format_list_bulleted,
            size: 16,
            color: Color(0xFF90DFFF),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.flow.totalQuestions} questions total',
            style: AppTextStyles.small.copyWith(
              color: const Color(0xFFD4EFFC),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '~3 min',
            style: AppTextStyles.small.copyWith(
              color: const Color(0xFF90DFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = widget.flow.questions[_questionIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
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
        border: Border.all(
          color: const Color.fromRGBO(127, 227, 255, 0.4),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 20, 40, 0.4),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title,
            style: AppTextStyles.headline.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          if (question.subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(question.subtitle, style: AppTextStyles.small),
          ],
          const SizedBox(height: 16),
          if (question.type == QuestionInputType.text)
            TextQuestionInput(
              controller: _textControllers.putIfAbsent(
                _questionIndex,
                () => TextEditingController(text: question.initialValue ?? ''),
              ),
              placeholder: question.placeholder,
              minLines: question.minLines,
              maxLines: question.maxLines,
            )
          else if (question.type == QuestionInputType.select)
            DropdownSelectInput(
              options: question.options,
              selected: _selectSelections[_questionIndex],
              onSelect: (val) =>
                  setState(() => _selectSelections[_questionIndex] = val),
            )
          else if (question.type == QuestionInputType.slider)
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
          const SizedBox(height: 20),
          FlowFooterButtons(
            secondaryLabel: 'Skip',
            onSecondary: () => _advanceOrFinish(wasAnswered: false),
            primaryLabel: _isLastQuestion
                ? 'Save & finish later →'
                : 'Continue →',
            isPrimaryLoading: _isSaving,
            onPrimary: () => _advanceOrFinish(wasAnswered: true),
          ),
        ],
      ),
    );
  }
}
