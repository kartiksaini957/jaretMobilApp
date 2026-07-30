import 'package:flutter_riverpod/flutter_riverpod.dart';

class CorrectionItem {
  const CorrectionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.applied = true,
  });

  final String id;
  final String title;
  final String description;
  final String date;
  /// True while the correction is in effect; false once undone/dismissed.
  final bool applied;

  CorrectionItem copyWith({bool? applied}) => CorrectionItem(
    id: id,
    title: title,
    description: description,
    date: date,
    applied: applied ?? this.applied,
  );
}

class AiCorrectionsState {
  const AiCorrectionsState({
    this.corrections = const [
      CorrectionItem(
        id: 'supply_chain',
        title: 'Supply chain',
        description: '"We buy from three suppliers, not one."',
        date: 'Jun 30',
      ),
      CorrectionItem(
        id: 'storefront_read',
        title: 'Storefront read confirmed',
        description: 'signage wear, Government St',
        date: 'Jun 22',
      ),
      CorrectionItem(
        id: 'watch_area',
        title: 'Watch area dismissed',
        description: '"lot competition"',
        date: 'Jun 12',
        applied: false,
      ),
    ],
    this.lastClassificationRun = 'Jun 12 · v7',
  });

  final List<CorrectionItem> corrections;
  final String lastClassificationRun;

  AiCorrectionsState copyWith({
    List<CorrectionItem>? corrections,
    String? lastClassificationRun,
  }) {
    return AiCorrectionsState(
      corrections: corrections ?? this.corrections,
      lastClassificationRun:
          lastClassificationRun ?? this.lastClassificationRun,
    );
  }
}

/// AI & Corrections tab: every correction the user has made, and controls
/// to undo/restore them. Corrections always win over the model's own read.
class AiCorrectionsController extends Notifier<AiCorrectionsState> {
  @override
  AiCorrectionsState build() => const AiCorrectionsState();

  void toggleApplied(String id) {
    state = state.copyWith(
      corrections: [
        for (final c in state.corrections)
          if (c.id == id) c.copyWith(applied: !c.applied) else c,
      ],
    );
  }

  void rerunClassification() {
    state = state.copyWith(lastClassificationRun: 'Just now · v8');
  }
}

final aiCorrectionsProvider =
    NotifierProvider<AiCorrectionsController, AiCorrectionsState>(
      AiCorrectionsController.new,
    );
