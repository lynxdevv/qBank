import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/topic_type.dart';
import '../utils/constants.dart';
import 'importance_dots.dart';
import 'year_tags.dart';

class TopicTile extends StatelessWidget {
  final Topic topic;
  final bool isDone;
  final VoidCallback onToggleDone;
  final VoidCallback onTap;

  const TopicTile({
    super.key,
    required this.topic,
    required this.isDone,
    required this.onToggleDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: 5,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.doneGreen.withAlpha(20)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isDone
                ? AppColors.doneGreen.withAlpha(60)
                : Colors.white.withAlpha(15),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggleDone,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.doneGreen : Colors.transparent,
                  border: Border.all(
                    color: isDone
                        ? AppColors.doneGreen
                        : AppColors.textSecondary.withAlpha(120),
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: topic.type == TopicType.essay
                              ? AppColors.essayColor.withAlpha(40)
                              : AppColors.shortColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          topic.type == TopicType.essay ? 'E' : 'S',
                          style: TextStyle(
                            color: topic.type == TopicType.essay
                                ? AppColors.essayColor
                                : AppColors.shortColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          topic.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ImportanceDots(importance: topic.importance),
                      const SizedBox(width: 12),
                      Expanded(
                        child: YearTags(yearsAsked: topic.yearsAsked),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
