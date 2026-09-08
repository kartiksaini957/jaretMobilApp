import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupExportHelper {
  /// Escapes a single CSV field according to RFC 4180 standard:
  /// wraps in double quotes if it contains commas, double quotes, or newlines,
  /// and doubles any internal double quotes.
  static String _escapeCsvField(dynamic value) {
    if (value == null) return '';
    final str = (value is Map || value is List) ? jsonEncode(value) : value.toString();
    final needsQuoting = str.contains(',') ||
        str.contains('"') ||
        str.contains('\n') ||
        str.contains('\r');
    if (!needsQuoting) return str;
    return '"${str.replaceAll('"', '""')}"';
  }

  /// Formats a list of rows into CSV content
  static String _formatCsvRows(List<List<dynamic>> rows) {
    return rows.map((row) => row.map(_escapeCsvField).join(',')).join('\r\n');
  }

  /// Converts dynamic API data into CSV format
  static String _convertToCsv(Map<String, dynamic> responseData) {
    final rawData = responseData['data'];

    // 1. If data is null or empty
    if (rawData == null) {
      return '';
    }

    // 2. If rawData is already a CSV string
    if (rawData is String) {
      return rawData;
    }

    // 3. If rawData is a List of records
    if (rawData is List) {
      if (rawData.isEmpty) {
        // Return empty CSV content (as requested: "agr khali aata hai to khali he downlaod krvan hai")
        return '';
      }

      // If list of Maps (table rows)
      if (rawData.first is Map) {
        final headers = <String>{};
        for (final item in rawData) {
          if (item is Map) {
            headers.addAll(item.keys.map((k) => k.toString()));
          }
        }

        final headerList = headers.toList();
        final rows = <List<dynamic>>[headerList];

        for (final item in rawData) {
          if (item is Map) {
            final row = headerList.map((header) => item[header]).toList();
            rows.add(row);
          } else {
            rows.add([item]);
          }
        }

        return _formatCsvRows(rows);
      }

      // If list of primitives
      final rows = rawData.map((e) => [e]).toList();
      return _formatCsvRows(rows);
    }

    // 4. If rawData is a Map
    if (rawData is Map) {
      if (rawData.isEmpty) {
        return '';
      }

      // Check if this map is a collection of tables: e.g. { "users": [...], "invoices": [...] }
      final hasListValues = rawData.values.any((v) => v is List && v.isNotEmpty);
      if (hasListValues) {
        final buffer = StringBuffer();
        for (final entry in rawData.entries) {
          buffer.writeln('=== ${entry.key} ===');
          final tableData = entry.value;
          if (tableData is List && tableData.isNotEmpty && tableData.first is Map) {
            final headers = <String>{};
            for (final item in tableData) {
              if (item is Map) {
                headers.addAll(item.keys.map((k) => k.toString()));
              }
            }
            final headerList = headers.toList();
            final rows = <List<dynamic>>[headerList];
            for (final item in tableData) {
              if (item is Map) {
                final row = headerList.map((header) => item[header]).toList();
                rows.add(row);
              }
            }
            buffer.writeln(_formatCsvRows(rows));
          } else if (tableData is List) {
            final rows = tableData.map((e) => [e]).toList();
            buffer.writeln(_formatCsvRows(rows));
          } else {
            buffer.writeln(entry.value?.toString() ?? '');
          }
          buffer.writeln();
        }
        return buffer.toString().trim();
      }

      // Single object key-value pairs
      final rows = <List<dynamic>>[['Key', 'Value']];
      for (final entry in rawData.entries) {
        rows.add([entry.key.toString(), entry.value]);
      }
      return _formatCsvRows(rows);
    }

    return '';
  }

  /// Saves the backup API response to a local file in the temporary directory
  /// and triggers the native system share/download dialog to save the file.
  static Future<File> saveBackupToFileAndShare(
    Map<String, dynamic> data, {
    String format = 'json',
  }) async {
    final String formattedContent;
    final String mimeType;
    final String extension = format.toLowerCase().trim();

    if (extension == 'csv') {
      formattedContent = _convertToCsv(data);
      mimeType = 'text/csv';
    } else {
      formattedContent = const JsonEncoder.withIndent('  ').convert(data);
      mimeType = 'application/json';
    }

    final dir = await getTemporaryDirectory();
    final safeTimestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[^0-9]'), '')
        .padRight(14, '0')
        .substring(0, 14);

    final fileName = 'lightsignal_backup_$safeTimestamp.$extension';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(formattedContent);

    debugPrint(
      '[BackupExportHelper] File written to ${file.path} (${file.lengthSync()} bytes)',
    );

    await Share.shareXFiles(
      [
        XFile(
          file.path,
          mimeType: mimeType,
          name: fileName,
        ),
      ],
      subject: 'LightSignal Backup Export ($extension)',
      text: 'LightSignal Backup Export ($extension)',
    );

    return file;
  }
}
