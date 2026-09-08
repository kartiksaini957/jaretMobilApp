import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../features/setting/model/diagnosticsExportModel.dart';

class DiagnosticsExportHelper {
  /// Escapes a single CSV field: wraps in quotes if it contains a comma,
  /// quote, or newline, and doubles any internal quotes.
  static String _escapeCsvField(String value) {
    final needsQuoting =
        value.contains(',') || value.contains('"') || value.contains('\n');
    if (!needsQuoting) return value;
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  static String _rowToCsvLine(List<String> row) {
    return row.map(_escapeCsvField).join(',');
  }

  /// Flattens the diagnostics data into CSV rows and saves the file,
  /// then opens the native share/save sheet so the user can store it
  /// wherever they want (Downloads, Files app, Drive, etc.).
  static Future<File> exportToCsvAndShare(DiagnosticsExportData data) async {
    final rows = <List<String>>[
      ['Section', 'Field', 'Value'],
      ['Account', 'User ID', data.userId],
      ['Account', 'Export Timestamp', data.exportTimestamp],
      ['QuickBooks', 'Connected', data.quickbooks.connected.toString()],
      ['QuickBooks', 'Last Sync', data.quickbooks.lastSync],
      for (final pos in data.posIntegrations) ...[
        ['POS Integration', 'Provider', pos.provider],
        ['POS Integration', 'Connected', pos.connected.toString()],
        ['POS Integration', 'Updated At', pos.updatedAt],
      ],
      if (data.syncLogs.isEmpty)
        ['Sync Logs', 'Entries', 'None']
      else
        for (var i = 0; i < data.syncLogs.length; i++)
          ['Sync Logs', 'Entry ${i + 1}', data.syncLogs[i]],
    ];

    final csvString = rows.map(_rowToCsvLine).join('\r\n');

    final dir = await getTemporaryDirectory();
    final safeTimestamp = data.exportTimestamp
        .replaceAll(RegExp(r'[^0-9]'), '')
        .padRight(8, '0')
        .substring(0, 8);
    final file = File('${dir.path}/lightsignal_diagnostics_$safeTimestamp.csv');
    await file.writeAsString(csvString);

    await Share.shareXFiles([
      XFile(file.path, mimeType: 'text/csv'),
    ], subject: 'LightSignal Diagnostics Export');

    return file;
  }
}
