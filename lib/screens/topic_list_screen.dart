import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/topic_type.dart';
import '../providers/progress_provider.dart';
import '../services/topic_cache.dart';
import '../utils/constants.dart';
import '../widgets/filter_bar.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/topic_tile.dart';
import 'topic_detail_screen.dart';

class TopicListScreen extends StatefulWidget {
  final String assetPath;
  final String unitName;

  const TopicListScreen({
    super.key,
    required this.assetPath,
    required this.unitName,
  });

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  TopicType? _selectedType;
  SortOption _sortOption = SortOption.timesAsked;
  List<Topic> _allTopics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    try {
      final loaded = await TopicCache.instance.get(widget.assetPath);
      if (mounted) {
        setState(() {
          _allTopics = loaded;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('TopicList: error loading ${widget.assetPath}: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<Topic> get _filteredTopics {
    var topics = List<Topic>.from(_allTopics);

    if (_selectedType != null) {
      topics = topics.where((t) => t.type == _selectedType).toList();
    }

    switch (_sortOption) {
      case SortOption.timesAsked:
        if (_selectedType == null) {
          final essays = topics.where((t) => t.type == TopicType.essay).toList()
            ..sort((a, b) => b.timesAsked.compareTo(a.timesAsked));
          final shorts = topics.where((t) => t.type == TopicType.short).toList()
            ..sort((a, b) => b.timesAsked.compareTo(a.timesAsked));
          topics = [...essays, ...shorts];
        } else {
          topics.sort((a, b) => b.timesAsked.compareTo(a.timesAsked));
        }
        break;
      case SortOption.importance:
        topics.sort((a, b) => b.importance.compareTo(a.importance));
        break;
      case SortOption.recent:
        topics.sort((a, b) {
          final aYear = a.yearsAsked.isNotEmpty
              ? _extractYear(a.yearsAsked.first)
              : 0;
          final bYear = b.yearsAsked.isNotEmpty
              ? _extractYear(b.yearsAsked.first)
              : 0;
          return bYear.compareTo(aYear);
        });
        break;
      case SortOption.alphabetical:
        topics.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return topics;
  }

  int _extractYear(String yearStr) {
    final parts = yearStr.split('-');
    if (parts.isNotEmpty) {
      return int.tryParse(parts.first) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final filtered = _filteredTopics;
    final allIds = _allTopics.map((t) => t.id).toList();
    final doneCount = progress.doneCount(allIds);

    return GradientScaffold(
      appBar: AppBar(
        title: Text(widget.unitName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$doneCount / ${allIds.length} topics completed',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentCyan))
          : Column(
              children: [
                FilterBar(
                  selectedType: _selectedType,
                  sortOption: _sortOption,
                  onTypeChanged: (type) {
                    setState(() => _selectedType = type);
                  },
                  onSortChanged: (sort) {
                    setState(() => _sortOption = sort);
                  },
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            'No topics found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 32),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final topic = filtered[index];
                            return TopicTile(
                              topic: topic,
                              isDone: progress.isDone(topic.id),
                              onToggleDone: () {
                                progress.toggleDone(topic.id);
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TopicDetailScreen(
                                      topic: topic,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
