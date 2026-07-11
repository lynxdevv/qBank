import '../models/topic.dart';
import '../services/csv_loader.dart';

class TopicCache {
  static final instance = TopicCache._();
  TopicCache._();

  final _cache = <String, List<Topic>>{};

  Future<List<Topic>> get(String assetPath) async {
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }
    final topics = await CsvLoader.loadFromAsset(assetPath);
    _cache[assetPath] = topics;
    return topics;
  }

  Future<int> count(String assetPath) async {
    final topics = await get(assetPath);
    return topics.length;
  }
}
