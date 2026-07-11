import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qbank_lynx/services/csv_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads a bundled CSV asset into topics', () async {
    final topics = await CsvLoader.loadFromAsset(
      'assets/questions/Pathology/paper1/Cell Injury, Cell Death and Adaptations.csv',
    );

    expect(topics, isNotEmpty);
    expect(topics.first.id, isNotEmpty);
  });
}
