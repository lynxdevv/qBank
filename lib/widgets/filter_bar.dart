import 'package:flutter/material.dart';
import '../models/topic_type.dart';
import '../utils/constants.dart';

enum SortOption { importance, recent, alphabetical }

class FilterBar extends StatelessWidget {
  final TopicType? selectedType;
  final SortOption sortOption;
  final ValueChanged<TopicType?> onTypeChanged;
  final ValueChanged<SortOption> onSortChanged;

  const FilterBar({
    super.key,
    required this.selectedType,
    required this.sortOption,
    required this.onTypeChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: selectedType == null,
            onTap: () => onTypeChanged(null),
          ),
          const SizedBox(width: 6),
          _FilterChip(
            label: 'Essay',
            selected: selectedType == TopicType.essay,
            onTap: () => onTypeChanged(TopicType.essay),
            color: AppColors.essayColor,
          ),
          const SizedBox(width: 6),
          _FilterChip(
            label: 'Short',
            selected: selectedType == TopicType.short,
            onTap: () => onTypeChanged(TopicType.short),
            color: AppColors.shortColor,
          ),
          const Spacer(),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: AppColors.textSecondary, size: 20),
            onSelected: onSortChanged,
            color: AppColors.surfaceLight,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.importance,
                child: Text('Importance', style: TextStyle(color: AppColors.textPrimary)),
              ),
              const PopupMenuItem(
                value: SortOption.recent,
                child: Text('Most Recent', style: TextStyle(color: AppColors.textPrimary)),
              ),
              const PopupMenuItem(
                value: SortOption.alphabetical,
                child: Text('A-Z', style: TextStyle(color: AppColors.textPrimary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.accentCyan;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? chipColor.withAlpha(40) : Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? chipColor : Colors.white.withAlpha(30),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? chipColor : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
