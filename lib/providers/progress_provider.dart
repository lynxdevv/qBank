import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider extends ChangeNotifier {
  static const _key = 'done_topics';
  Set<String> _doneTopics = {};
  bool _loaded = false;

  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      final list = (json.decode(jsonStr) as List).cast<String>();
      _doneTopics = list.toSet();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(_doneTopics.toList()));
  }

  bool isDone(String topicId) => _doneTopics.contains(topicId);

  Future<void> toggleDone(String topicId) async {
    if (_doneTopics.contains(topicId)) {
      _doneTopics.remove(topicId);
    } else {
      _doneTopics.add(topicId);
    }
    await _save();
    notifyListeners();
  }

  int doneCount(List<String> topicIds) {
    return topicIds.where((id) => _doneTopics.contains(id)).length;
  }

  double progressForIds(List<String> topicIds) {
    if (topicIds.isEmpty) return 0.0;
    return doneCount(topicIds) / topicIds.length;
  }
}
