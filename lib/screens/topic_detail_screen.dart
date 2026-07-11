import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/topic_type.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';
import '../utils/id_utils.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/importance_dots.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isDone = progress.isDone(topic.id);
    final descLines = topic.parsedDescriptionLines;

    return GradientScaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDone ? Icons.check_circle : Icons.check_circle_outline,
              color: isDone ? AppColors.doneGreen : AppColors.textSecondary,
            ),
            onPressed: () => progress.toggleDone(topic.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _InfoChip(
                  label: topic.type == TopicType.essay ? 'Essay' : 'Short Answer',
                  color: topic.type == TopicType.essay
                      ? AppColors.essayColor
                      : AppColors.shortColor,
                ),
                const SizedBox(width: 8),
                if (topic.hasPreviouslyBeenAsked)
                  const _InfoChip(
                    label: 'Previously Asked',
                    color: AppColors.accentCyan,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Importance: ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                ImportanceDots(importance: topic.importance),
                const SizedBox(width: 8),
                Text(
                  '${topic.importance}/7',
                  style: const TextStyle(
                    color: AppColors.importanceGold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (topic.timesAsked > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.history, color: AppColors.accentCyan, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Asked ${topic.timesAsked} time${topic.timesAsked > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: AppColors.accentCyan,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: topic.yearsAsked.map((y) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.accentCyan.withAlpha(60),
                      ),
                    ),
                    child: Text(
                      y,
                      style: const TextStyle(
                        color: AppColors.accentCyan,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (descLines.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Key Points',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...descLines.map((line) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6, right: 10),
                          child: Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.accentCyan,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            if (topic.references.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'References',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...topic.references.map((ref) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.book_outlined,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              IdUtils.formatBookCode(ref.bookCode) +
                                  (ref.edition != null
                                      ? ' ${ref.edition}th Ed'
                                      : '') +
                                  (ref.page != null ? ', p.${ref.page}' : ''),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
