import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool useDarkGradient;

  const GradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.useDarkGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: body,
      ),
    );
  }
}
