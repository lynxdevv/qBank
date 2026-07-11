import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ImportanceDots extends StatelessWidget {
  final int importance;
  final int maxImportance;

  const ImportanceDots({
    super.key,
    required this.importance,
    this.maxImportance = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxImportance, (index) {
        final filled = index < importance;
        return Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Icon(
            Icons.circle,
            size: 8,
            color: filled ? AppColors.importanceGold : Colors.white.withAlpha(40),
          ),
        );
      }),
    );
  }
}
