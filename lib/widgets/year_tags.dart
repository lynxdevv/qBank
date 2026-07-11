import 'package:flutter/material.dart';
import '../utils/constants.dart';

class YearTags extends StatelessWidget {
  final List<String> yearsAsked;

  const YearTags({super.key, required this.yearsAsked});

  @override
  Widget build(BuildContext context) {
    if (yearsAsked.isEmpty) {
      return const Text(
        'Never asked',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
      );
    }

    final displayYears = yearsAsked.length > 4
        ? yearsAsked.sublist(0, 4)
        : yearsAsked;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displayYears.map((y) {
          final yearDisplay = y.contains('-') ? y.split('-').first : y;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              yearDisplay,
              style: const TextStyle(
                color: AppColors.accentCyan,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
        if (yearsAsked.length > 4)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '+${yearsAsked.length - 4}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }
}
