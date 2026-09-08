import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

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
    this.isRunningClassifier = false,
    this.togglingCorrectionId,
    this.error,
  });

  final List<CorrectionItem> corrections;
  final String lastClassificationRun;
  final bool isRunningClassifier;
  final String? togglingCorrectionId;
  final String? error;

  AiCorrectionsState copyWith({
    List<CorrectionItem>? corrections,
    String? lastClassificationRun,
    bool? isRunningClassifier,
    String? togglingCorrectionId,
    bool clearTogglingCorrectionId = false,
    String? error,
  }) {
    return AiCorrectionsState(
      corrections: corrections ?? this.corrections,
      lastClassificationRun:
          lastClassificationRun ?? this.lastClassificationRun,
      isRunningClassifier: isRunningClassifier ?? this.isRunningClassifier,
      togglingCorrectionId: clearTogglingCorrectionId
          ? null
          : (togglingCorrectionId ?? this.togglingCorrectionId),
      error: error,
    );
  }
}

class AiCorrectionsController extends Notifier<AiCorrectionsState> {
  @override
  AiCorrectionsState build() => const AiCorrectionsState();

  /// Calls POST /api/corrections/{id}/undo and flips the local applied flag
  /// on success. Works for both "Undo" (applied -> false) and "Restore"
  /// (applied -> true) since the same endpoint just toggles the state.
  Future<void> toggleApplied(String id) async {
    state = state.copyWith(togglingCorrectionId: id, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().undoCorrection(accessToken: token, correctionId: id);
      if (!ref.mounted) return;
      state = state.copyWith(
        corrections: [
          for (final c in state.corrections)
            if (c.id == id) c.copyWith(applied: !c.applied) else c,
        ],
        clearTogglingCorrectionId: true,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not update correction.';
      state = state.copyWith(clearTogglingCorrectionId: true, error: message);
    }
  }

  Future<void> rerunClassification() async {
    state = state.copyWith(isRunningClassifier: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().runClassifier(accessToken: token);
      if (!ref.mounted) return;
      state = state.copyWith(
        lastClassificationRun: 'Just now',
        isRunningClassifier: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not start classification.';
      state = state.copyWith(isRunningClassifier: false, error: message);
    }
  }
}

final aiCorrectionsProvider =
    NotifierProvider<AiCorrectionsController, AiCorrectionsState>(
      AiCorrectionsController.new,
    );