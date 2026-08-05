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
        id: 'snap_jun_2026',
        timestamp: 'Jun 28, 2026',
        label: 'full snapshot',
      ),
      SnapshotItem(
        id: 'snap_may_2026',
        timestamp: 'May 28, 2026',
        label: 'full snapshot',
      ),
    ],
    this.cloudSyncOk = true,
    this.cloudSyncLastRun = '4h ago',
  });

  final List<SnapshotItem> snapshots;
  final bool cloudSyncOk;

  /// Freshness for the cloud-sync status line.
  final String cloudSyncLastRun;

  /// "Cloud sync: healthy · last run 4h ago".
  String get cloudSyncLabel =>
      'Cloud sync: ${cloudSyncOk ? 'healthy' : 'failing'} · '
      'last run $cloudSyncLastRun';

  BackupState copyWith({
    List<SnapshotItem>? snapshots,
    bool? cloudSyncOk,
    String? cloudSyncLastRun,
  }) {
    return BackupState(
      snapshots: snapshots ?? this.snapshots,
      cloudSyncOk: cloudSyncOk ?? this.cloudSyncOk,
      cloudSyncLastRun: cloudSyncLastRun ?? this.cloudSyncLastRun,
    );
  }
}

/// Backup & Export tab: on-demand exports plus the list of saved snapshots.
class BackupController extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupState();

  void createBackup() {
    final now = DateTime.now();
    state = state.copyWith(
      snapshots: [
        SnapshotItem(
          id: 'snap_${now.microsecondsSinceEpoch}',
          timestamp: _formatDate(now),
          label: 'full snapshot',
        ),
        ...state.snapshots,
      ],
      cloudSyncLastRun: 'just now',
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Matches the reference's "Jun 28, 2026" snapshot labels.
  static String _formatDate(DateTime d) =>
      '${_months[d.month - 1]} ${d.day}, ${d.year}';

  void deleteSnapshot(String id) {
    state = state.copyWith(
      snapshots: state.snapshots.where((s) => s.id != id).toList(),
    );
  }
}

final backupProvider = NotifierProvider<BackupController, BackupState>(
  BackupController.new,
);
