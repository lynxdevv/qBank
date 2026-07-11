import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/topic.dart';

class CsvLoader {
  static Future<List<Topic>> loadFromAsset(String assetPath) async {
    try {
      var data = await rootBundle.loadString(assetPath);
      if (data.isNotEmpty && data.codeUnitAt(0) == 0xFEFF) {
        data = data.substring(1);
      }

      final rows = _parseCsv(data);
      if (rows.isEmpty) return [];

      final headers = rows.first.map((h) => h.trim().replaceAll('\uFEFF', '')).toList();
      final topics = <Topic>[];

      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty || row.every((cell) => cell.trim().isEmpty)) continue;

        final map = <String, String>{};
        for (var j = 0; j < headers.length && j < row.length; j++) {
          final key = headers[j];
          if (key.isEmpty) continue;
          map[key] = row[j].trim();
        }

        final id = map['Id'] ?? map['id'] ?? '';
        final title = map['Title'] ?? map['title'] ?? '';
        if (id.isEmpty || title.isEmpty) continue;

        topics.add(Topic.fromCsvRow(map));
      }

      if (topics.isEmpty) {
        debugPrint('CsvLoader warning: loaded zero topics from $assetPath');
      }
      return topics;
    } catch (e) {
      debugPrint('CsvLoader error for $assetPath: $e');
      return [];
    }
  }

  static List<List<String>> _parseCsv(String text) {
    final rows = <List<String>>[];
    final currentRow = <String>[];
    var currentField = StringBuffer();
    var inQuotes = false;
    var i = 0;

    while (i < text.length) {
      final c = text[i];

      if (inQuotes) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            currentField.write('"');
            i += 2;
          } else {
            inQuotes = false;
            i++;
          }
        } else {
          currentField.write(c);
          i++;
        }
      } else {
        if (c == '"') {
          inQuotes = true;
          i++;
        } else if (c == ',') {
          currentRow.add(currentField.toString());
          currentField = StringBuffer();
          i++;
        } else if (c == '\r') {
          currentRow.add(currentField.toString());
          currentField = StringBuffer();
          if (i + 1 < text.length && text[i + 1] == '\n') i++;
          i++;
          rows.add(List<String>.from(currentRow));
          currentRow.clear();
        } else if (c == '\n') {
          currentRow.add(currentField.toString());
          currentField = StringBuffer();
          i++;
          rows.add(List<String>.from(currentRow));
          currentRow.clear();
        } else {
          currentField.write(c);
          i++;
        }
      }
    }

    if (currentField.isNotEmpty || currentRow.isNotEmpty) {
      currentRow.add(currentField.toString());
      rows.add(List<String>.from(currentRow));
    }

    return rows;
  }
}
