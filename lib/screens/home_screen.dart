import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../services/asset_registry.dart';
import '../services/topic_cache.dart';
import '../utils/constants.dart';
import '../widgets/gradient_scaffold.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAllTopicIds();
  }

  Future<void> _loadAllTopicIds() async {
    final allIds = <List<String>>[];
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
          } catch (_) {}
        }
      }
      allIds.add(ids);
    }
    if (mounted) {
      setState(() {
        _subjectTopicIds = allIds;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          'qBank Lynx',
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
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              itemCount: AssetRegistry.subjects.length,
              itemBuilder: (context, index) {
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
              },
            ),
    );
  }
}
