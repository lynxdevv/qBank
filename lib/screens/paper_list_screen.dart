import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../services/asset_registry.dart';
import '../services/topic_cache.dart';
import '../utils/constants.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/progress_ring.dart';
import 'topic_list_screen.dart';

class PaperListScreen extends StatefulWidget {
  final SubjectDef subject;

  const PaperListScreen({super.key, required this.subject});

  @override
  State<PaperListScreen> createState() => _PaperListScreenState();
}

class _PaperListScreenState extends State<PaperListScreen> {
  final Map<String, List<String>> _paperTopicIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopicIds();
  }

  Future<void> _loadTopicIds() async {
    for (final paper in widget.subject.papers) {
      final ids = <String>[];
      for (final file in paper.csvFiles) {
        final path = AssetRegistry.assetPath(
          widget.subject.directoryName,
          paper.directoryName,
          file,
        );
        try {
          final topics = await TopicCache.instance.get(path);
          ids.addAll(topics.map((t) => t.id));
        } catch (e) {
          debugPrint('PaperList: error loading $path: $e');
        }
      }
      _paperTopicIds[paper.directoryName] = ids;
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return GradientScaffold(
      appBar: AppBar(
        title: Text(widget.subject.displayName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentCyan),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              itemCount: widget.subject.papers.length,
              itemBuilder: (context, index) {
                final paper = widget.subject.papers[index];
                final topicIds =
                    _paperTopicIds[paper.directoryName] ?? <String>[];
                final done = progress.doneCount(topicIds);
                final total = topicIds.length;
                final pct = total > 0 ? done / total : 0.0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicListScreen(
                          subject: widget.subject,
                          paper: paper,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                      border: Border.all(color: Colors.white.withAlpha(15)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paper.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$total topics  |  $done completed',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Colors.white.withAlpha(20),
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.accentCyan,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ProgressRing(progress: pct, size: 48, strokeWidth: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
