import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/topic.dart';

class CsvLoader {
  static final _converter = const CsvToListConverter(shouldParseNumbers: false);

  static Future<List<Topic>> loadFromAsset(String assetPath) async {
    final data = await rootBundle.loadString(assetPath);
    final rows = _converter.convert(data);

    if (rows.isEmpty) return [];

    final headers = rows.first.map((h) => h.toString().trim()).toList();
    final topics = <Topic>[];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || row.every((cell) => cell.toString().trim().isEmpty)) continue;

      final map = <String, String>{};
      for (var j = 0; j < headers.length && j < row.length; j++) {
        map[headers[j]] = row[j].toString().trim();
      }

      final id = map['Id'] ?? '';
      final title = map['Title'] ?? '';
      if (id.isEmpty || title.isEmpty) continue;

      topics.add(Topic.fromCsvRow(map));
    }

    return topics;
  }
}
