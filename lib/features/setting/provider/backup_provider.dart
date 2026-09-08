import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';
import '../../../utils/backup_export_helper.dart';
import '../model/unified_snapshots_model.dart';

class BackupState {
  const BackupState({
    this.snapshots = const [],
    this.cloudSyncOk = true,
    this.cloudSyncLastRun = 'up to date',
    this.isLoading = false,
    this.isLoadingSnapshots = false,
    this.errorMessage,
  });

  final List<UnifiedSnapshotItem> snapshots;
  final bool cloudSyncOk;
  final String cloudSyncLastRun;
  final bool isLoading;
  final bool isLoadingSnapshots;
  final String? errorMessage;

  String get cloudSyncLabel =>
      'Cloud sync: ${cloudSyncOk ? 'healthy' : 'failing'} · '
      'status: $cloudSyncLastRun';

  BackupState copyWith({
    List<UnifiedSnapshotItem>? snapshots,
    bool? cloudSyncOk,
    String? cloudSyncLastRun,
    bool? isLoading,
    bool? isLoadingSnapshots,
    String? errorMessage,
  }) {
    return BackupState(
      snapshots: snapshots ?? this.snapshots,
      cloudSyncOk: cloudSyncOk ?? this.cloudSyncOk,
      cloudSyncLastRun: cloudSyncLastRun ?? this.cloudSyncLastRun,
      isLoading: isLoading ?? this.isLoading,
      isLoadingSnapshots: isLoadingSnapshots ?? this.isLoadingSnapshots,
      errorMessage: errorMessage,
    );
  }
}

class BackupController extends Notifier<BackupState> {
  @override
  BackupState build() {
    Future.microtask(() => fetchSnapshots());
    return const BackupState(isLoadingSnapshots: true);
  }

  Future<void> fetchSnapshots() async {
    state = state.copyWith(isLoadingSnapshots: true, errorMessage: null);
    try {
      final res = await ApiService().getUnifiedSnapshots();
      state = state.copyWith(
        snapshots: res.data,
        isLoadingSnapshots: false,
        cloudSyncOk: true,
        cloudSyncLastRun: res.data.isNotEmpty ? 'synced' : 'up to date',
      );
    } catch (e) {
      debugPrint('[BackupController] fetchSnapshots error: $e');
      state = state.copyWith(
        isLoadingSnapshots: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> createBackup({String format = 'json'}) async {
    state = state.copyWith(isLoading: true);
    try {
      final responseData =
          await ApiService().createBackupExport(format: format);

      // Save the response to a file and prompt download/share
      await BackupExportHelper.saveBackupToFileAndShare(
        responseData,
        format: format,
      );

      state = state.copyWith(
        cloudSyncLastRun: 'just now',
        cloudSyncOk: true,
        isLoading: false,
      );

      // Refresh snapshots after export
      await fetchSnapshots();
      return true;
    } catch (e) {
      debugPrint('[BackupController] createBackup error: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  void deleteSnapshot(String id) {
    state = state.copyWith(
      snapshots:
          state.snapshots.where((s) => s.snapshotId != id).toList(),
    );
  }
}

final backupProvider = NotifierProvider<BackupController, BackupState>(
  BackupController.new,
);
