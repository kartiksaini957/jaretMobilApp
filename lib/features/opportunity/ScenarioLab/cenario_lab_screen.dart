import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/model/scenario_lab_model.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/widgets/key_numbers_grid.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/app_nav_drawer.dart';
import 'package:flutter_application_1/widgets/customAppbar.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../widgets/app_nav_destinations.dart';

class LS {
  static const fg = Color(0xFFFFFFFF);
  static const soft = Color(0xFFCFEFFB);
  static const mute = Color(0xFFA7DCF0);
  static const good = Color(0xFF7BEFD0);
  static const goodText = Color(0xFFA6F5DC);
  static const warn = Color(0xFFFFD98A);
  static const warnText = Color(0xFFFFD466);
  static const crit = Color(0xFFFF7A7A);
  static const accent = Color(0xFF5FE0FF);
  static const ink = Color(0xFF04303F);
  static const sevCritical = Color(0xFFFF5757);
  static const sevBuilding = Color(0xFFFFD466);
  static const sevStable = Color(0xFFFFFFFF);
  static const sevResolved = Color(0xFF26C281);
  static const bg1 = Color(0xFF2BD4FF);
  static const bg2 = Color(0xFF18A8DC);
  static const bg3 = Color(0xFF0E9ED0);
  static const bg4 = Color(0xFF1AAEDE);
  static const bgBase1 = Color(0xFF064A63);
  static const bgBase2 = Color(0xFF05688A);
  static const bgBase3 = Color(0xFF0892C0);
  static const scrimTop = Color(0x57082838);
  static const scrimBot = Color(0x4D082838);
  static const bodyBg = Color(0xFF0A2733);
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(.16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LS.scrimTop, LS.scrimBot, Colors.white.withOpacity(.03)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.05),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(.05),
            blurRadius: 0,
            spreadRadius: -.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: padding,
      child: DefaultTextStyle.merge(
        style: AppTextStyles.body.copyWith(
          shadows: const [
            Shadow(
              color: Color(0x66001220),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class TtrCard {
  final String eyebrow, title;
  final List<String> body;
  final String? gate;
  TtrCard(this.eyebrow, this.title, this.body, {this.gate});
}

class WheelNode {
  final String title, kpi, kpiLabel, time, body, action;
  WheelNode(
    this.title,
    this.kpi,
    this.kpiLabel,
    this.time,
    this.body,
    this.action,
  );
}

enum SectionKind { ttr, wheel }

class Section {
  final String key, label;
  final SectionKind kind;
  final List<TtrCard>? cards;
  final List<WheelNode>? nodes;
  final String? wheelName;
  Section.ttr(this.key, this.label, this.cards)
      : kind = SectionKind.ttr,
        nodes = null,
        wheelName = null;
  Section.wheel(this.key, this.label, this.wheelName, this.nodes)
      : kind = SectionKind.wheel,
        cards = null;
}

const kSectionOrder = ['steps', 'pros', 'cons', 'keep', 'peer', 'alt'];

const kTileIcons = {
  'steps': Icons.checklist_rtl_rounded,
  'pros': Icons.thumb_up_alt_outlined,
  'cons': Icons.thumb_down_alt_outlined,
  'keep': Icons.warning_amber_rounded,
  'peer': Icons.groups_2_outlined,
  'alt': Icons.share_outlined,
};

const kTileColors = {
  'steps': LS.accent,
  'pros': LS.sevResolved,
  'cons': LS.sevCritical,
  'keep': LS.sevBuilding,
  'peer': Color(0xFF7E8CE6),
  'alt': Color(0xFF3FB4C4),
};

@immutable
class ScenarioLabState {
  final bool isLoading;
  final String? errorMessage;
  final bool started;
  final String? question;
  final ScenarioResponse? scenarioResponse;
  final List<Map<String, dynamic>> history;
  final String? openSection;
  final Map<String, int> ttrIndex;
  final Map<String, Set<int>> revealedInk;
  final Set<String> exploredTiles;
  final Set<String> openTip;
  final bool assumeOpen;
  final Map<String, int?> wheelSelected;
  final Map<String, Set<int>> wheelSeen;
  final int? chartHoverIdx;

  const ScenarioLabState({
    this.isLoading = false,
    this.errorMessage,
    this.started = false,
    this.question,
    this.scenarioResponse,
    this.history = const [],
    this.openSection,
    this.ttrIndex = const {},
    this.revealedInk = const {},
    this.exploredTiles = const {},
    this.openTip = const {},
    this.assumeOpen = false,
    this.wheelSelected = const {},
    this.wheelSeen = const {},
    this.chartHoverIdx,
  });

  ScenarioData? get data => scenarioResponse?.data;

  ScenarioLabState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? started,
    String? question,
    ScenarioResponse? scenarioResponse,
    List<Map<String, dynamic>>? history,
    String? openSection,
    bool clearOpenSection = false,
    Map<String, int>? ttrIndex,
    Map<String, Set<int>>? revealedInk,
    Set<String>? exploredTiles,
    Set<String>? openTip,
    bool? assumeOpen,
    Map<String, int?>? wheelSelected,
    Map<String, Set<int>>? wheelSeen,
    int? chartHoverIdx,
    bool clearChartHover = false,
  }) {
    return ScenarioLabState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      started: started ?? this.started,
      question: question ?? this.question,
      scenarioResponse: scenarioResponse ?? this.scenarioResponse,
      history: history ?? this.history,
      openSection: clearOpenSection ? null : (openSection ?? this.openSection),
      ttrIndex: ttrIndex ?? this.ttrIndex,
      revealedInk: revealedInk ?? this.revealedInk,
      exploredTiles: exploredTiles ?? this.exploredTiles,
      openTip: openTip ?? this.openTip,
      assumeOpen: assumeOpen ?? this.assumeOpen,
      wheelSelected: wheelSelected ?? this.wheelSelected,
      wheelSeen: wheelSeen ?? this.wheelSeen,
      chartHoverIdx: clearChartHover ? null : (chartHoverIdx ?? this.chartHoverIdx),
    );
  }
}

class ScenarioLabNotifier extends StateNotifier<ScenarioLabState> {
  final ApiService _apiService;

  ScenarioLabNotifier(this._apiService) : super(const ScenarioLabState());

  Future<void> submitQuestion(String question) async {
    final cleanQuestion = question.trim();
    if (cleanQuestion.isEmpty) return;

    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      started: true,
      question: cleanQuestion,
    );

    try {
      final response = await _apiService.runScenario(
        question: cleanQuestion,
        history: state.history,
      );

      final newHistory = List<Map<String, dynamic>>.from(state.history);
      newHistory.add({'role': 'user', 'content': cleanQuestion});
      if (response.data != null) {
        newHistory.add({
          'role': 'assistant',
          'content': jsonEncode(response.data!.toJson()),
        });
      }

      state = state.copyWith(
        isLoading: false,
        scenarioResponse: response,
        history: newHistory,
        clearOpenSection: true,
        ttrIndex: {},
        revealedInk: {},
        wheelSelected: {},
        wheelSeen: {},
      );
    } catch (e) {
      debugPrint('[ScenarioLabNotifier] Error running scenario: $e');
      final errorStr = e
          .toString()
          .replaceFirst('ApiException: ', '')
          .replaceFirst('ApiException(null): ', '')
          .replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorStr.isEmpty ? 'Failed to analyze scenario.' : errorStr,
      );
    }
  }

  void resetScenario() {
    state = const ScenarioLabState();
  }

  void toggleTile(String key) {
    final explored = {...state.exploredTiles};
    if (state.openSection == key) {
      explored.add(key);
      state = state.copyWith(exploredTiles: explored, clearOpenSection: true);
      return;
    }
    if (state.openSection != null) explored.add(state.openSection!);
    final ttrIndex = {...state.ttrIndex};
    ttrIndex.putIfAbsent(key, () => 0);
    state = state.copyWith(
      exploredTiles: explored,
      openSection: key,
      ttrIndex: ttrIndex,
    );
  }

  void closePanel() {
    final explored = {...state.exploredTiles};
    if (state.openSection != null) explored.add(state.openSection!);
    state = state.copyWith(exploredTiles: explored, clearOpenSection: true);
  }

  void openSection(String key) {
    final ttrIndex = {...state.ttrIndex}..putIfAbsent(key, () => 0);
    state = state.copyWith(openSection: key, ttrIndex: ttrIndex);
  }

  void setTtrIndex(String key, int index) {
    final ttrIndex = {...state.ttrIndex, key: index};
    state = state.copyWith(ttrIndex: ttrIndex);
  }

  void revealInk(String key, int idx) {
    final revealed = {...state.revealedInk};
    revealed[key] = {...(revealed[key] ?? {}), idx};
    state = state.copyWith(revealedInk: revealed);
  }

  void toggleTip(String key) {
    final open = {...state.openTip};
    if (open.contains(key)) {
      open.remove(key);
    } else {
      open
        ..clear()
        ..add(key);
    }
    state = state.copyWith(openTip: open);
  }

  void dismissTip(String key) {
    final open = {...state.openTip}..remove(key);
    state = state.copyWith(openTip: open);
  }

  void toggleAssume() {
    state = state.copyWith(assumeOpen: !state.assumeOpen);
  }

  void wheelSelect(String sectionKey, int i) {
    final sel = {...state.wheelSelected, sectionKey: i};
    final seenMap = {...state.wheelSeen};
    seenMap[sectionKey] = {...(seenMap[sectionKey] ?? {}), i};
    state = state.copyWith(wheelSelected: sel, wheelSeen: seenMap);
  }

  void setChartHover(int? idx) {
    state = state.copyWith(chartHoverIdx: idx, clearChartHover: idx == null);
  }
}

final scenarioLabProvider =
    StateNotifierProvider.autoDispose<ScenarioLabNotifier, ScenarioLabState>((
  ref,
) {
  return ScenarioLabNotifier(ApiService());
});

class ScenariooLabScreen extends ConsumerStatefulWidget {
  const ScenariooLabScreen({super.key});

  @override
  ConsumerState<ScenariooLabScreen> createState() => _ScenarioLabScreenState();
}

class _ScenarioLabScreenState extends ConsumerState<ScenariooLabScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _onDrawerItemSelected(BuildContext context, int index) {
    openNavDestination(context, index, currentIndex: AppNavIndex.scenarioLab);
  }

  void _toggleTile(String key) =>
      ref.read(scenarioLabProvider.notifier).toggleTile(key);
  void _closePanel() => ref.read(scenarioLabProvider.notifier).closePanel();

  void _submitQuestion([String? text]) {
    final value = (text ?? _questionController.text).trim();
    if (value.isEmpty) return;
    ref.read(scenarioLabProvider.notifier).submitQuestion(value);
    _questionController.clear();
    FocusScope.of(context).unfocus();
  }

  Map<String, Section> _buildDynamicSections(ScenarioData? data) {
    if (data == null) return {};

    // 1. Steps
    final stepCards = data.steps.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      final eyebrow = 'STEP ${i + 1} OF ${data.steps.length}'
          '${s.customerExperienceElement != null && s.customerExperienceElement!.isNotEmpty ? ' · CUSTOMER EXPERIENCE' : ''}';
      final bodyLines = <String>[];
      if (s.what != null && s.what!.isNotEmpty) bodyLines.add(s.what!);
      if (s.how != null && s.how!.isNotEmpty) bodyLines.add('How: ${s.how!}');
      if (s.why != null && s.why!.isNotEmpty) bodyLines.add('Why: ${s.why!}');
      if (s.customerExperienceElement != null &&
          s.customerExperienceElement!.isNotEmpty) {
        bodyLines.add(s.customerExperienceElement!);
      }
      return TtrCard(
        eyebrow,
        s.title,
        bodyLines,
        gate: s.decisionGate != null && s.decisionGate!.isNotEmpty
            ? 'Gate: ${s.decisionGate!}'
            : null,
      );
    }).toList();

    // 2. Pros
    final proNodes = data.pros.map((p) {
      final kpi = p.impactText ??
          (p.dollarImpact != null
              ? (p.dollarImpact! >= 0
                  ? '+\$${p.dollarImpact!.toStringAsFixed(0)}'
                  : '-\$${p.dollarImpact!.abs().toStringAsFixed(0)}')
              : '');
      return WheelNode(
        p.pro,
        kpi,
        ' impact',
        p.timeDimension ?? '',
        p.detail ?? p.plainLanguage ?? '',
        p.actionToCapture ?? p.meaning ?? '',
      );
    }).toList();

    // 3. Cons
    final conNodes = data.cons.map((c) {
      final kpi = c.impactText ??
          (c.dollarImpact != null
              ? (c.dollarImpact! >= 0
                  ? '+\$${c.dollarImpact!.toStringAsFixed(0)}'
                  : '-\$${c.dollarImpact!.abs().toStringAsFixed(0)}')
              : '');
      return WheelNode(
        c.con,
        kpi,
        ' risk',
        c.timeDimension ?? '',
        c.detail ?? c.plainLanguage ?? '',
        c.mitigation ?? c.consequence ?? '',
      );
    }).toList();

    // 4. Things to keep in mind
    final keepNodes = data.thingsToKeepInMind.asMap().entries.map((entry) {
      final text = entry.value;
      var title = text;
      if (title.contains('—')) {
        title = title.split('—').first.trim();
      } else if (title.contains(':')) {
        title = title.split(':').first.trim();
      } else if (title.length > 36) {
        title = '${title.substring(0, 34)}…';
      }
      return WheelNode(
        title,
        'Notice',
        '',
        'Strategic factor',
        text,
        'Factor this consideration into your roadmap',
      );
    }).toList();

    // 5. Peer context
    final peerCards = [
      TtrCard(
        'COMPARABLE-MARKET PATTERN',
        'What comparable operators see',
        [
          data.peerContext != null && data.peerContext!.isNotEmpty
              ? data.peerContext!
              : 'No peer context available for this scenario.',
        ],
      ),
      TtrCard(
        'WHERE THIS COMES FROM',
        'Read this as a pattern, not a promise',
        [
          'This context is drawn from industry benchmarks and comparable business models — your live performance will validate the trajectory.',
        ],
      ),
    ];

    // 6. Alternatives
    final altCards = data.alternatives.asMap().entries.map((entry) {
      final i = entry.key;
      final a = entry.value;
      final bodyLines = <String>[];
      if (a.costImpact != null && a.costImpact!.isNotEmpty) {
        bodyLines.add('Cost impact: ${a.costImpact!}');
      }
      if (a.riskComparison != null && a.riskComparison!.isNotEmpty) {
        bodyLines.add('Risk comparison: ${a.riskComparison!}');
      }
      if (a.bestFor != null && a.bestFor!.isNotEmpty) {
        bodyLines.add('Best for: ${a.bestFor!}');
      }
      return TtrCard(
        'ALTERNATIVE ${i + 1} OF ${data.alternatives.length}',
        a.description ?? 'Alternative Option',
        bodyLines,
      );
    }).toList();

    return {
      'steps': Section.ttr('steps', 'Steps to take', stepCards),
      'pros': Section.wheel('pros', 'Pros — what you gain', 'Pros', proNodes),
      'cons': Section.wheel('cons', 'Cons — what it costs you', 'Cons', conNodes),
      'keep': Section.wheel('keep', 'Things to keep in mind', 'Keep', keepNodes),
      'peer': Section.ttr('peer', 'Peer context', peerCards),
      'alt': Section.ttr('alt', 'Alternatives', altCards),
    };
  }

  String _getTileHint(String key, ScenarioData? data) {
    if (data == null) return '';
    switch (key) {
      case 'steps':
        final gateCount = data.steps
            .where((s) => s.decisionGate != null && s.decisionGate!.isNotEmpty)
            .length;
        return '${data.steps.length} steps · $gateCount decision gates';
      case 'pros':
        return '${data.pros.length} upsides, each priced';
      case 'cons':
        return '${data.cons.length} risks, each with a fix';
      case 'keep':
        return '${data.thingsToKeepInMind.length} strategic considerations';
      case 'peer':
        return 'What comparable operators see';
      case 'alt':
        return '${data.alternatives.length} other routes, costed';
      default:
        return '';
    }
  }

  Color _getColorForFlag(String? colorFlag, String? severity) {
    final flag = colorFlag?.toLowerCase();
    final sev = severity?.toLowerCase();
    if (flag == 'green' || sev == 'resolved') {
      return const Color(0xFF6FDB6C);
    }
    if (flag == 'cyan' || sev == 'stable') {
      return const Color(0xFF5FE0FF);
    }
    if (flag == 'amber' || flag == 'yellow' || sev == 'building') {
      return const Color(0xFFFFC24B);
    }
    if (flag == 'red' || sev == 'critical') {
      return const Color(0xFFFF5757);
    }
    return const Color(0xFF5FE0FF);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scenarioLabProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(
        title: 'Scenario Lab',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 5,
        onItemSelected: (index) {
          _onDrawerItemSelected(context, index);
        },
      ),
      body: GradientBackground(
        child: SafeArea(
          child: state.started ? _analysisScreen(state) : _emptyState(state),
        ),
      ),
    );
  }

  Widget _emptyState(ScenarioLabState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: GlassCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          "✦",
                          style: TextStyle(
                            fontSize: 40,
                            color: Color(0xFF5FE0FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Ask your first what-if question',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Type any business scenario above — what if I hired '
                        'someone, what if a competitor opened nearby, what if '
                        'I raised my prices.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14.5,
                          color: LS.soft,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _suggestionChip('What if I hired one more person'),
                          _suggestionChip('What if a competitor opened nearby'),
                          _suggestionChip('What if I raised my prices 10%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _followUpBar(state.isLoading),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label) {
    return GestureDetector(
      onTap: () => _submitQuestion(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(.28)),
          color: Colors.white.withOpacity(.05),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return GlassCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.threeArchedCircle(
            color: const Color(0xFF5FE0FF),
            size: 46,
          ),
          const SizedBox(height: 22),
          Text(
            'Analyzing scenario with live financial data...',
            textAlign: TextAlign.center,
            style: AppTextStyles.headline.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Evaluating revenue capacity, labor models, and cash reserve buffers...',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: LS.soft,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget(String message) {
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF5757),
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Unable to complete analysis',
            style: AppTextStyles.headline.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: LS.soft,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final q = ref.read(scenarioLabProvider).question;
              if (q != null && q.isNotEmpty) {
                _submitQuestion(q);
              }
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: LS.accent.withOpacity(.25),
              foregroundColor: Colors.white,
              side: BorderSide(color: LS.accent.withOpacity(.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisScreen(ScenarioLabState state) {
    final data = state.data;
    final sections = _buildDynamicSections(data);

    final keyNumbersData = (data?.keyNumbers ?? []).map((kpi) {
      final flag = kpi.colorFlag?.toLowerCase();
      final sev = kpi.severity?.toLowerCase();
      final isGlowing = flag == 'amber' ||
          flag == 'yellow' ||
          sev == 'building' ||
          sev == 'critical';
      return KeyNumberData(
        label: kpi.label.toUpperCase(),
        value: kpi.value,
        note: kpi.source ?? '',
        dotColor: _getColorForFlag(kpi.colorFlag, kpi.severity),
        showGlow: isGlowing,
      );
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _conversationBubble(state.question),
            const SizedBox(height: 14),
            if (state.isLoading) ...[
              _loadingWidget(),
              const SizedBox(height: 14),
            ] else if (state.errorMessage != null) ...[
              _errorWidget(state.errorMessage!),
              const SizedBox(height: 14),
            ] else if (data != null) ...[
              _verdictCard(data.verdict),
              if (keyNumbersData.isNotEmpty) ...[
                const SizedBox(height: 18),
                _eyebrow('Key numbers'),
                const SizedBox(height: 10),
                KeyNumbersGrid(numbers: keyNumbersData),
              ],
              if (sections.isNotEmpty) ...[
                const SizedBox(height: 18),
                _eyebrow('Full analysis'),
                const SizedBox(height: 10),
                _sixTileSection(sections, data),
              ],
              if (data.chartData != null) ...[
                const SizedBox(height: 18),
                _chartCard(data.chartData!),
              ],
              const SizedBox(height: 18),
              _actionBar(data),
              if (data.closingLine != null && data.closingLine!.isNotEmpty) ...[
                const SizedBox(height: 14),
                _disclaimer(data.closingLine!),
              ],
            ],
            const SizedBox(height: 14),
            _followUpBar(state.isLoading),
          ],
        ),
      ),
    );
  }

  Widget _eyebrow(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: LS.scrimTop,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(.18)),
          ),
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _conversationBubble(String? question) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .82,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(8, 40, 56, 0.34),
                Color.fromRGBO(255, 255, 255, 0.04),
              ],
              stops: [0.0, 1.0],
            ),
            color: const Color(0xFF0D4A63),
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Text(
            question ?? '',
            style: AppTextStyles.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }

  Widget _verdictCard(ScenarioVerdict? verdict) {
    if (verdict == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(160 * pi / 180),
          colors: [
            Color.fromRGBO(8, 40, 56, 0.24),
            Color.fromRGBO(8, 40, 56, 0.20),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.30),
            width: 1.25,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(160 * pi / 180),
            colors: [
              Color.fromRGBO(255, 255, 255, 0.14),
              Color.fromRGBO(255, 255, 255, 0.05),
              Color.fromRGBO(255, 255, 255, 0.03),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verdict.label ?? 'Verdict',
              style: AppTextStyles.headline.copyWith(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (verdict.category != null && verdict.category!.isNotEmpty)
                  _pill(verdict.category!, LS.accent, null),
                if (verdict.confidence != null && verdict.confidence!.isNotEmpty)
                  _pill(
                    'Confidence: ${verdict.confidence}',
                    LS.sevBuilding,
                    'tip_conf',
                    verdict.confidenceReason,
                  ),
                if (verdict.risk != null && verdict.risk!.isNotEmpty)
                  _pill(
                    'Risk: ${verdict.risk}',
                    LS.sevCritical,
                    'tip_risk',
                    verdict.riskReason,
                  ),
              ],
            ),
            if (verdict.summary != null && verdict.summary!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                verdict.summary!,
                style: AppTextStyles.body.copyWith(fontSize: 15, height: 1.65),
              ),
            ],
            if (verdict.reserveWarning != null &&
                verdict.reserveWarning!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(.18)),
                  color: Colors.white.withOpacity(.05),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: LS.sevBuilding,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        verdict.reserveWarning!,
                        style: AppTextStyles.small.copyWith(
                          fontSize: 13,
                          color: LS.warn,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color dot, String? tipKey, [String? tip]) {
    final open = tipKey != null &&
        ref.watch(scenarioLabProvider).openTip.contains(tipKey);
    final maxPillWidth = MediaQuery.of(context).size.width - 64;

    return GestureDetector(
      onTap: tipKey == null
          ? null
          : () {
              final notifier = ref.read(scenarioLabProvider.notifier);
              notifier.toggleTip(tipKey);
              if (!open) {
                Future.delayed(const Duration(seconds: 4), () {
                  if (mounted) notifier.dismissTip(tipKey);
                });
              }
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: maxPillWidth),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(.22)),
              color: Colors.white.withOpacity(.08),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dot,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.small.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (tipKey != null && tip != null && tip.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
          if (open && tip != null && tip.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: BoxConstraints(maxWidth: maxPillWidth),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xF2063C46),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(.18)),
              ),
              child: Text(
                tip,
                style: AppTextStyles.small.copyWith(
                  fontSize: 12,
                  color: LS.soft,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sixTileSection(Map<String, Section> sections, ScenarioData? data) {
    final openSection = ref.watch(scenarioLabProvider).openSection;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(160 * pi / 180),
          colors: [
            Color.fromRGBO(8, 40, 56, 0.24),
            Color.fromRGBO(8, 40, 56, 0.20),
          ],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tiles = kSectionOrder.where((k) => sections.containsKey(k)).toList();
          final rows = <List<String>>[];
          for (var i = 0; i < tiles.length; i += 2) {
            rows.add(tiles.sublist(i, math.min(i + 2, tiles.length)));
          }
          int? openRow;
          if (openSection != null) {
            for (var r = 0; r < rows.length; r++) {
              if (rows[r].contains(openSection)) openRow = r;
            }
          }
          final children = <Widget>[];
          for (var r = 0; r < rows.length; r++) {
            children.add(
              Row(
                children: <Widget>[
                  for (var j = 0; j < rows[r].length; j++) ...[
                    Expanded(child: _tile(rows[r][j], sections[rows[r][j]]!, data)),
                    if (j == 0 && rows[r].length > 1) const SizedBox(width: 11),
                  ],
                ],
              ),
            );
            if (r != rows.length - 1) children.add(const SizedBox(height: 11));
            if (openRow == r && openSection != null && sections.containsKey(openSection)) {
              children.add(const SizedBox(height: 11));
              children.add(_panel(openSection, sections[openSection]!));
            }
          }
          return Column(children: children);
        },
      ),
    );
  }

  Widget _tile(String key, Section section, ScenarioData? data) {
    final labState = ref.watch(scenarioLabProvider);
    final isOpen = labState.openSection == key;
    final explored = labState.exploredTiles.contains(key);
    final color = kTileColors[key] ?? LS.accent;
    final glow = !isOpen && !explored;
    final hint = _getTileHint(key, data);

    return GestureDetector(
      onTap: () => _toggleTile(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minHeight: 106),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(.10),
          border: Border.all(color: color.withOpacity(.42)),
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: const Color(0xB0E0F6FF).withOpacity(.1),
                    blurRadius: 2,
                    spreadRadius: .1,
                  ),
                  BoxShadow(
                    color: const Color(0x47C6ECFF).withOpacity(.1),
                    blurRadius: 2,
                    spreadRadius: .3,
                  ),
                ]
              : null,
        ),
        transform: isOpen
            ? (Matrix4.identity()..scale(.97))
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              kTileIcons[key] ?? Icons.insights,
              color: Colors.white.withOpacity(.95),
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              section.label.split(' — ').first,
              style: AppTextStyles.body.copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              style: AppTextStyles.body.copyWith(
                fontSize: 11.5,
                color: LS.soft,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(String key, Section section) {
    if (section.kind == SectionKind.ttr) {
      return _ttrPanel(section);
    }
    return _wheelPanel(section);
  }

  Widget _ttrPanel(Section section) {
    final labState = ref.watch(scenarioLabProvider);
    final cards = section.cards ?? [];
    if (cards.isEmpty) return const SizedBox.shrink();

    final rawIdx = labState.ttrIndex[section.key] ?? 0;
    final idx = rawIdx.clamp(0, cards.length - 1);
    final card = cards[idx];
    final revealed = (labState.revealedInk[section.key] ?? {}).contains(idx);

    return Container(
      key: ValueKey('panel_${section.key}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.label,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: LS.soft, size: 18),
                onPressed: _closePanel,
              ),
            ],
          ),
          Row(
            children: List.generate(cards.length, (i) {
              final done = i < idx, active = i == idx;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: done || active
                        ? Colors.white.withOpacity(active ? .92 : .45)
                        : Colors.white.withOpacity(.18),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              color: Colors.white.withOpacity(.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.eyebrow,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  card.title,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 9),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    revealed
                        ? _ttrBody(card)
                        : ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Opacity(opacity: .35, child: _ttrBody(card)),
                          ),
                    if (!revealed)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(scenarioLabProvider.notifier)
                              .revealInk(section.key, idx),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 13),
                if (card.gate != null)
                  Row(
                    children: [
                      Expanded(
                        child: _gatePill(
                          idx < cards.length - 1
                              ? 'Continue to step ${idx + 2}'
                              : 'Got it',
                          true,
                          () {
                            if (idx < cards.length - 1) {
                              ref
                                  .read(scenarioLabProvider.notifier)
                                  .setTtrIndex(section.key, idx + 1);
                            } else {
                              _closePanel();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _gatePill('See alternatives', false, () {
                          ref
                              .read(scenarioLabProvider.notifier)
                              .openSection('alt');
                        }),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _arrowBtn(
                        Icons.chevron_left_rounded,
                        idx > 0,
                        () => ref
                            .read(scenarioLabProvider.notifier)
                            .setTtrIndex(section.key, idx - 1),
                      ),
                      _arrowBtn(
                        Icons.chevron_right_rounded,
                        idx < cards.length - 1,
                        () => ref
                            .read(scenarioLabProvider.notifier)
                            .setTtrIndex(section.key, idx + 1),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ttrBody(TtrCard card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in card.body) ...[
          Text(
            p,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: LS.soft,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 9),
        ],
        if (card.gate != null)
          Text(
            card.gate!,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: LS.warnText,
              height: 1.6,
            ),
          ),
      ],
    );
  }

  Widget _gatePill(String label, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primary
                ? LS.accent.withOpacity(.55)
                : Colors.white.withOpacity(.22),
          ),
          color: primary
              ? LS.accent.withOpacity(.2)
              : Colors.white.withOpacity(.07),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _arrowBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : .35,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(.22)),
            color: Colors.white.withOpacity(.12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _wheelPanel(Section section) {
    final labState = ref.watch(scenarioLabProvider);
    final nodes = section.nodes ?? [];
    if (nodes.isEmpty) return const SizedBox.shrink();

    final selected = labState.wheelSelected[section.key];
    final seen = labState.wheelSeen[section.key] ?? {};
    final color = kTileColors[section.key] ?? LS.accent;

    return Container(
      key: ValueKey('panel_${section.key}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.label,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: LS.soft, size: 18),
                onPressed: _closePanel,
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: GestureDetector(
                onTapUp: (details) {
                  final local = details.localPosition;
                  const cx = 130.0, cy = 130.0;
                  final dx = local.dx - cx, dy = local.dy - cy;
                  final dist = math.sqrt(dx * dx + dy * dy);
                  if (dist < 44 || dist > 120) return;
                  var angle = math.atan2(dy, dx) * 180 / math.pi;
                  angle = (angle + 90 + 360) % 360;
                  final n = nodes.length;
                  final segAngle = 360 / n;
                  final i = (angle / segAngle).floor().clamp(0, n - 1);
                  ref.read(scenarioLabProvider.notifier).wheelSelect(section.key, i);
                },
                child: CustomPaint(
                  painter: _WheelPainter(
                    count: nodes.length,
                    color: color,
                    seen: seen,
                    labels: nodes.map((n) => n.title).toList(),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.13),
                        border: Border.all(
                          color: Colors.white.withOpacity(.32),
                        ),
                      ),
                      child: Text(
                        section.wheelName ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              color: Colors.white.withOpacity(.04),
            ),
            child: selected == null
                ? Text(
                    'Select a segment to reveal it.',
                    style: AppTextStyles.body.copyWith(
                      color: LS.soft,
                      fontSize: 13.5,
                    ),
                  )
                : _wheelDetail(nodes[selected.clamp(0, nodes.length - 1)]),
          ),
        ],
      ),
    );
  }

  Widget _wheelDetail(WheelNode n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          n.title,
          style: AppTextStyles.headline.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (n.kpi.isNotEmpty) ...[
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LS.goodText,
              ),
              children: [
                TextSpan(text: n.kpi),
                TextSpan(
                  text: n.kpiLabel,
                  style: AppTextStyles.body.copyWith(
                    color: LS.soft,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (n.time.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            'When: ${n.time}',
            style: AppTextStyles.body.copyWith(fontSize: 12, color: LS.warnText),
          ),
        ],
        if (n.body.isNotEmpty) ...[
          const SizedBox(height: 7),
          Text(
            n.body,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: LS.soft,
              height: 1.6,
            ),
          ),
        ],
        if (n.action.isNotEmpty) ...[
          const SizedBox(height: 9),
          Text(
            '→ ${n.action}',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: LS.soft,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _chartCard(ScenarioChartData chartData) {
    final hoverIdx = ref.watch(scenarioLabProvider).chartHoverIdx;
    final notifier = ref.read(scenarioLabProvider.notifier);

    final labels = chartData.labels;
    final projData = chartData.series.isNotEmpty
        ? chartData.series.first.data
        : <double>[];
    final worstData = chartData.worstCaseSeries?.data ?? <double>[];
    final floorMarker = chartData.markers
        .where((m) => m.type?.toLowerCase() == 'floor')
        .firstOrNull;
    final beMarker = chartData.markers
        .where((m) => m.type?.toLowerCase() == 'breakeven')
        .firstOrNull;

    final floorValue = floorMarker?.value;
    final floorLabel = floorMarker?.label ?? 'Reserve floor';
    final breakEvenIdx = beMarker?.monthIndex;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _eyebrow('Cash position over time'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _legendSwatch(LS.accent, 'Projected'),
              if (worstData.isNotEmpty)
                _legendSwatch(LS.crit, 'Worst case', dashed: true),
              if (floorValue != null)
                _legendSwatch(LS.warnText, floorLabel, dashed: true),
              if (breakEvenIdx != null)
                _legendSwatch(LS.sevResolved, 'Break-even', dot: true),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onPanUpdate: (d) => notifier.setChartHover(
                    _nearestChartIndex(
                      d.localPosition,
                      context.size ?? const Size(300, 230),
                      labels.length,
                    ),
                  ),
                  onPanEnd: (_) => notifier.setChartHover(null),
                  onTapUp: (d) => notifier.setChartHover(
                    _nearestChartIndex(
                      d.localPosition,
                      context.size ?? const Size(300, 230),
                      labels.length,
                    ),
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _DynamicChartPainter(
                      labels: labels,
                      projected: projData,
                      worstCase: worstData,
                      floorValue: floorValue,
                      floorLabel: floorLabel,
                      breakEvenIdx: breakEvenIdx,
                      hoverIdx: hoverIdx,
                    ),
                  ),
                );
              },
            ),
          ),
          if (hoverIdx != null && hoverIdx < labels.length)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xEB063C46),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(.16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      labels[hoverIdx].toUpperCase(),
                      style: AppTextStyles.body.copyWith(
                        fontSize: 10,
                        color: LS.soft,
                        letterSpacing: .5,
                      ),
                    ),
                    if (hoverIdx < projData.length)
                      Text(
                        '\$${projData[hoverIdx].toStringAsFixed(0)} projected',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: LS.accent,
                        ),
                      ),
                    if (hoverIdx < worstData.length)
                      Text(
                        '\$${worstData[hoverIdx].toStringAsFixed(0)} worst case',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12,
                          color: LS.soft,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  int _nearestChartIndex(Offset pos, Size size, int count) {
    if (count <= 1) return 0;
    const x0 = 42.0, x1pad = 14.0;
    final x1 = size.width - x1pad;
    double best = double.infinity;
    int bestI = 0;
    for (var i = 0; i < count; i++) {
      final x = x0 + i * (x1 - x0) / (count - 1);
      final d = (x - pos.dx).abs();
      if (d < best) {
        best = d;
        bestI = i;
      }
    }
    return bestI;
  }

  Widget _legendSwatch(
    Color c,
    String label, {
    bool dashed = false,
    bool dot = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          )
        else
          Container(
            width: 14,
            height: 3,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.body.copyWith(fontSize: 11, color: LS.soft),
        ),
      ],
    );
  }

  Widget _actionBar(ScenarioData data) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _openSheet(_SheetKind.save, data),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(.05),
              side: BorderSide(color: LS.accent.withOpacity(.55)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save scenario',
              style: AppTextStyles.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _ghostBtn(
                'Adjust an assumption',
                () => _openSheet(_SheetKind.adjust, data),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _ghostBtn(
                'New scenario',
                () => _openSheet(_SheetKind.newScenario, data),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ghostBtn(String label, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(.06),
          side: BorderSide(color: Colors.white.withOpacity(.24)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: LS.soft,
          ),
        ),
      ),
    );
  }

  Widget _disclaimer(String closingLine) {
    return Text(
      closingLine,
      textAlign: TextAlign.center,
      style: AppTextStyles.body.copyWith(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }

  Widget _followUpBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(.22)),
        color: LS.scrimTop.withOpacity(0.15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _questionController,
              enabled: !isLoading,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 14.5,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submitQuestion(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ask a what-if question…',
                hintStyle: AppTextStyles.body.copyWith(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LS.accent.withOpacity(.2),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LS.accent,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_upward_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
              onPressed: isLoading ? null : () => _submitQuestion(),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  void _openSheet(_SheetKind kind, [ScenarioData? data]) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF08364C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => _buildSheet(kind, ctx, data),
    );
  }

  Widget _buildSheet(_SheetKind kind, BuildContext ctx, [ScenarioData? data]) {
    Widget content;
    switch (kind) {
      case _SheetKind.save:
        content = _saveSheet(ctx, data);
        break;
      case _SheetKind.newScenario:
        content = _newSheet(ctx);
        break;
      case _SheetKind.adjust:
        content = _adjustSheet(ctx, data);
        break;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.3),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveSheet(BuildContext ctx, [ScenarioData? data]) {
    final title = data?.verdict?.label ??
        ref.read(scenarioLabProvider).question ??
        'Saved Scenario';
    final controller = TextEditingController(text: title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save this scenario',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "It stays in your Scenario Lab history with today's assumptions and chart.",
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            color: LS.soft,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: controller,
          style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(.18)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _sheetPrimaryBtn('Confirm save', () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Scenario "${controller.text}" saved!'),
              backgroundColor: const Color(0xFF0D4A63),
            ),
          );
        }),
        const SizedBox(height: 9),
        _sheetGhostBtn('Cancel', () => Navigator.pop(ctx)),
      ],
    );
  }

  Widget _newSheet(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start a new scenario?',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Starting fresh clears these results. You can save this one first — it takes a second.',
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            color: LS.soft,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        _sheetPrimaryBtn('Save this scenario first', () {
          Navigator.pop(ctx);
          Future.delayed(
            const Duration(milliseconds: 180),
            () => _openSheet(_SheetKind.save),
          );
        }),
        const SizedBox(height: 9),
        _sheetGhostBtn('Start fresh', () {
          Navigator.pop(ctx);
          ref.read(scenarioLabProvider.notifier).resetScenario();
        }),
      ],
    );
  }

  Widget _adjustSheet(BuildContext ctx, [ScenarioData? data]) {
    final assumptions = data?.assumptionsTable ?? [];
    return StatefulBuilder(
      builder: (context, setLocal) {
        int? selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adjust an assumption',
              style: AppTextStyles.headline.copyWith(
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a value to change it, then rerun.',
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                color: LS.soft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.45,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: assumptions.length,
                itemBuilder: (context, i) {
                  final r = assumptions[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(
                            i == assumptions.length - 1 ? 0 : .1,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.item,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              if (r.source != null && r.source!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  r.source!,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 10.5,
                                    color: LS.soft.withOpacity(0.7),
                                  ),
                                ),
                              ],
                              if (r.note != null &&
                                  r.note!.isNotEmpty &&
                                  selected == i) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    r.note!,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 11,
                                      color: LS.mute,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () => setLocal(
                              () => selected = selected == i ? null : i,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selected == i
                                    ? LS.accent.withOpacity(.25)
                                    : LS.scrimTop,
                                border: Border.all(
                                  color: selected == i
                                      ? LS.accent.withOpacity(.85)
                                      : Colors.white.withOpacity(.18),
                                ),
                              ),
                              child: Text(
                                r.value,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Adjusting reruns the scenario with updated factors.',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: LS.soft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _sheetPrimaryBtn('Rerun scenario', () {
              Navigator.pop(ctx);
              if (selected != null && selected! < assumptions.length) {
                final chosen = assumptions[selected!];
                _submitQuestion('What if ${chosen.item} changes to ${chosen.value}?');
              } else {
                final currentQ = ref.read(scenarioLabProvider).question;
                if (currentQ != null) _submitQuestion(currentQ);
              }
            }),
            const SizedBox(height: 9),
            _sheetGhostBtn('Cancel', () => Navigator.pop(ctx)),
          ],
        );
      },
    );
  }

  Widget _sheetPrimaryBtn(String label, VoidCallback onTap) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: LS.accent.withOpacity(.22),
            side: BorderSide(color: LS.accent.withOpacity(.55)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _sheetGhostBtn(String label, VoidCallback onTap) => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(.06),
            side: BorderSide(color: Colors.white.withOpacity(.24)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: LS.soft,
            ),
          ),
        ),
      );
}

enum _SheetKind { save, newScenario, adjust }

class _WheelPainter extends CustomPainter {
  final int count;
  final Color color;
  final Set<int> seen;
  final List<String> labels;
  _WheelPainter({
    required this.count,
    required this.color,
    required this.seen,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 0) return;
    final cx = size.width / 2, cy = size.height / 2;
    const ro = 118.0, ri = 48.0;
    final segAngle = 360 / count;
    const gap = 4.0;
    for (var i = 0; i < count; i++) {
      final a0 = -90.0 - segAngle / 2 + i * segAngle + gap / 2;
      final a1 = -90.0 - segAngle / 2 + (i + 1) * segAngle - gap / 2;
      final path = Path();
      final startOuter = _polar(cx, cy, ro, a0);
      path.moveTo(startOuter.dx, startOuter.dy);
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: ro),
        _rad(a0),
        _rad(a1 - a0),
        false,
      );
      final innerEnd = _polar(cx, cy, ri, a1);
      path.lineTo(innerEnd.dx, innerEnd.dy);
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: ri),
        _rad(a1),
        _rad(a0 - a1),
        false,
      );
      path.close();

      final isSeen = seen.contains(i);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0x400C1C28);
      if (!isSeen) {
        canvas.drawShadow(path, const Color(0xFFE0F6FF), 8, false);
      }
      canvas.drawPath(path, paint);
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25
        ..color = Colors.white.withOpacity(.42);
      canvas.drawPath(path, borderPaint);

      if (i < labels.length) {
        final mid = (a0 + a1) / 2;
        final lp = _polar(cx, cy, ro + 26, mid);
        final labelText = labels[i].length > 28
            ? '${labels[i].substring(0, 26)}…'
            : labels[i];
        final tp = TextPainter(
          text: TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: LS.soft.withOpacity(isSeen ? .85 : 1),
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          maxLines: 3,
        )..layout(maxWidth: 84);
        tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
      }
    }
  }

  double _rad(double deg) => deg * math.pi / 180;
  Offset _polar(double cx, double cy, double r, double deg) {
    final a = _rad(deg);
    return Offset(cx + r * math.cos(a), cy + r * math.sin(a));
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.seen.length != seen.length || old.count != count;
}

class _DynamicChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> projected;
  final List<double> worstCase;
  final double? floorValue;
  final String? floorLabel;
  final int? breakEvenIdx;
  final int? hoverIdx;

  _DynamicChartPainter({
    required this.labels,
    required this.projected,
    required this.worstCase,
    this.floorValue,
    this.floorLabel,
    this.breakEvenIdx,
    this.hoverIdx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (labels.isEmpty || projected.isEmpty) return;

    final allValues = <double>[
      ...projected,
      ...worstCase,
      if (floorValue != null) floorValue!,
    ];

    final rawMin = allValues.isEmpty ? 0.0 : allValues.reduce(math.min);
    final rawMax = allValues.isEmpty ? 100000.0 : allValues.reduce(math.max);
    final diff = rawMax - rawMin;
    final span = diff <= 0 ? 10000.0 : diff;
    final minV = math.max(0.0, rawMin - span * 0.18);
    final maxV = rawMax + span * 0.18;

    const top = 14.0, bottom = 205.0;
    final h = bottom - top;

    double yOf(double v) {
      return bottom - ((v - minV) / (maxV - minV)) * h;
    }

    double xOf(int i) {
      const x0 = 42.0, rightPad = 14.0;
      final x1 = size.width - rightPad;
      if (labels.length <= 1) return x0;
      return x0 + i * (x1 - x0) / (labels.length - 1);
    }

    // Gridlines (4 levels)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..strokeWidth = 1;
    for (var i = 1; i <= 4; i++) {
      final gv = minV + (maxV - minV) * (i / 4.0);
      final y = yOf(gv);
      canvas.drawLine(Offset(42, y), Offset(size.width - 14, y), gridPaint);
      final labelText = gv >= 1000
          ? '\$${(gv / 1000).toStringAsFixed(1).replaceAll('.0', '')}K'
          : '\$${gv.toStringAsFixed(0)}';
      _text(
        canvas,
        labelText,
        const Offset(2, 0),
        y,
        LS.soft,
        9.5,
        anchorLeft: true,
      );
    }

    // Floor dashed line
    if (floorValue != null) {
      final floorY = yOf(floorValue!);
      _dashedLine(
        canvas,
        Offset(42, floorY),
        Offset(size.width - 14, floorY),
        LS.warnText,
        1.25,
      );
      _text(
        canvas,
        floorLabel ?? 'Reserve floor',
        const Offset(42, 0),
        floorY - 14,
        LS.warnText,
        10,
        anchorLeft: true,
      );
    }

    // X Labels
    for (var i = 0; i < labels.length; i++) {
      _text(
        canvas,
        labels[i],
        Offset(xOf(i), 0),
        size.height - 8,
        LS.soft,
        9.5,
        center: true,
      );
    }

    // Worst-case dashed line
    if (worstCase.length > 1) {
      for (var i = 0; i < worstCase.length - 1; i++) {
        _dashedLine(
          canvas,
          Offset(xOf(i), yOf(worstCase[i])),
          Offset(xOf(i + 1), yOf(worstCase[i + 1])),
          LS.crit.withOpacity(.7),
          1.75,
        );
      }
    }

    // Projected glow line
    if (projected.isNotEmpty) {
      final projPath = Path()..moveTo(xOf(0), yOf(projected[0]));
      for (var i = 1; i < projected.length; i++) {
        projPath.lineTo(xOf(i), yOf(projected[i]));
      }

      canvas.drawPath(
        projPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.25
          ..color = LS.accent
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(
        projPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.25
          ..color = LS.accent
          ..strokeCap = StrokeCap.round,
      );

      // Low point marker
      double lowest = projected[0];
      int lowIdx = 0;
      for (var i = 1; i < projected.length; i++) {
        if (projected[i] < lowest) {
          lowest = projected[i];
          lowIdx = i;
        }
      }
      final lowPt = Offset(xOf(lowIdx), yOf(lowest));
      canvas.drawCircle(lowPt, 3.5, Paint()..color = LS.warnText);
      final lowText = lowest >= 1000
          ? 'Low \$${(lowest / 1000).toStringAsFixed(1).replaceAll('.0', '')}K'
          : 'Low \$${lowest.toStringAsFixed(0)}';
      _text(
        canvas,
        lowText,
        Offset(lowPt.dx, 0),
        lowPt.dy + 13,
        LS.warnText,
        9.5,
        center: true,
      );

      // Break-even marker
      if (breakEvenIdx != null &&
          breakEvenIdx! >= 0 &&
          breakEvenIdx! < projected.length) {
        final bePt = Offset(xOf(breakEvenIdx!), yOf(projected[breakEvenIdx!]));
        canvas.drawCircle(bePt, 5, Paint()..color = LS.sevResolved);
        _text(
          canvas,
          'Break-even',
          Offset(bePt.dx, 0),
          bePt.dy - 9,
          LS.sevResolved,
          9.5,
          center: true,
        );
      }
    }

    // Hover line and dot
    if (hoverIdx != null && hoverIdx! < labels.length && hoverIdx! < projected.length) {
      final hx = xOf(hoverIdx!);
      canvas.drawLine(
        Offset(hx, 14),
        Offset(hx, bottom),
        Paint()..color = Colors.white.withOpacity(.3),
      );
      final hp = Offset(hx, yOf(projected[hoverIdx!]));
      canvas.drawCircle(hp, 4, Paint()..color = LS.accent);
      canvas.drawCircle(
        hp,
        4,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = LS.ink,
      );
    }
  }

  void _dashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Color color,
    double width,
  ) {
    const dashLen = 5.0, gapLen = 4.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    double dist = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    while (dist < total) {
      final segEnd = math.min(dist + dashLen, total);
      canvas.drawLine(a + dir * dist, a + dir * segEnd, paint);
      dist += dashLen + gapLen;
    }
  }

  void _text(
    Canvas canvas,
    String text,
    Offset pos,
    double y,
    Color color,
    double size, {
    bool center = false,
    bool anchorLeft = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    double dx;
    if (center) {
      dx = pos.dx - tp.width / 2;
    } else if (anchorLeft) {
      dx = pos.dx;
    } else {
      dx = pos.dx - tp.width;
    }
    tp.paint(canvas, Offset(dx, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _DynamicChartPainter old) =>
      old.hoverIdx != hoverIdx ||
      old.projected != projected ||
      old.labels != labels;
}
