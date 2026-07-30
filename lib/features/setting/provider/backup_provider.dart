import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnapshotItem {
  const SnapshotItem({
    required this.id,
    required this.timestamp,
    required this.label,
  });

  final String id;
  final String timestamp;
  final String label;
}

class BackupState {
  const BackupState({
    this.snapshots = const [
      SnapshotItem(
        id: 'pre_deploy',
        timestamp: '2025-10-15T07:30:00Z',
        label: 'Pre-deploy',
      ),
    ],
    this.cloudSyncOk = true,
  });

  final List<SnapshotItem> snapshots;
  final bool cloudSyncOk;

  BackupState copyWith({List<SnapshotItem>? snapshots, bool? cloudSyncOk}) {
    return BackupState(
      snapshots: snapshots ?? this.snapshots,
      cloudSyncOk: cloudSyncOk ?? this.cloudSyncOk,
    );
  }
}

/// Backup & Export tab: on-demand exports plus the list of saved snapshots.
class BackupController extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupState();

  void createBackup() {
    final now = DateTime.now().toUtc().toIso8601String();
    state = state.copyWith(
      snapshots: [
        SnapshotItem(id: 'snap_$now', timestamp: now, label: 'Manual backup'),
        ...state.snapshots,
      ],
    );
  }

  void deleteSnapshot(String id) {
    state = state.copyWith(
      snapshots: state.snapshots.where((s) => s.id != id).toList(),
    );
  }
}

final backupProvider = NotifierProvider<BackupController, BackupState>(
  BackupController.new,
);
