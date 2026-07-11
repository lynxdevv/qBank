import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../services/asset_registry.dart';
import '../services/topic_cache.dart';
import '../utils/constants.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/progress_ring.dart';
import '../widgets/subject_card.dart';
import 'paper_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _icons = [
    Icons.biotech,
    Icons.medication,
    Icons.coronavirus,
  ];

  List<List<String>> _subjectTopicIds = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadAllTopicIds();
  }

  Future<void> _loadAllTopicIds() async {
    final allIds = <List<String>>[];
    final errors = <String>[];

    for (final subject in AssetRegistry.subjects) {
      final ids = <String>[];
      for (final paper in subject.papers) {
        for (final file in paper.csvFiles) {
          final path = AssetRegistry.assetPath(
            subject.directoryName,
            paper.directoryName,
            file,
          );
          try {
            final topics = await TopicCache.instance.get(path);
            ids.addAll(topics.map((t) => t.id));
          } catch (e) {
            final msg = 'Error loading $path: $e';
            debugPrint(msg);
            errors.add(msg);
          }
        }
      }
      allIds.add(ids);
    }
    if (mounted) {
      setState(() {
        _subjectTopicIds = allIds;
        _loading = false;
        _loadError = errors.isEmpty ? null : errors.join('\n');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    final allTopicIds = _subjectTopicIds.expand((ids) => ids).toList();
    final totalDone = progress.doneCount(allTopicIds);
    final totalTopics = allTopicIds.length;
    final overallPct = totalTopics > 0 ? totalDone / totalTopics : 0.0;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          'qBank 2',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentCyan),
            )
          : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              children: [
                if (_loadError != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(30),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(color: Colors.red.withAlpha(80)),
                    ),
                    child: Text(
                      'Some files failed to load. Check debug console.',
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (totalTopics == 0 && !_loading)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(30),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(color: Colors.orange.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No topics loaded',
                          style: TextStyle(
                            color: Colors.orange[300],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Run "flutter clean" then "flutter run" to rebuild assets.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Subjects: ${AssetRegistry.subjects.map((s) => s.displayName).join(", ")}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                _OverallProgress(
                  done: totalDone,
                  total: totalTopics,
                  progress: overallPct,
                ),
                const SizedBox(height: 8),
                ...List.generate(AssetRegistry.subjects.length, (index) {
                  final subject = AssetRegistry.subjects[index];
                  final topicIds = index < _subjectTopicIds.length
                      ? _subjectTopicIds[index]
                      : <String>[];
                  final done = progress.doneCount(topicIds);
                  final total = topicIds.length;
                  final pct = total > 0 ? done / total : 0.0;

                  return SubjectCard(
                    title: subject.displayName,
                    subtitle: '$done / $total topics completed',
                    progress: pct,
                    icon: _icons[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaperListScreen(subject: subject),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
    );
  }
}

class _OverallProgress extends StatelessWidget {
  final int done;
  final int total;
  final double progress;

  const _OverallProgress({
    required this.done,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B3E), Color(0xFF162350)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.accentCyan.withAlpha(60)),
      ),
      child: Row(
        children: [
          ProgressRing(progress: progress, size: 72, strokeWidth: 6),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$done / $total topics completed',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withAlpha(20),
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.accentCyan,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
