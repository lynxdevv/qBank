import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/progress_provider.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';

class QBanLynxApp extends StatelessWidget {
  const QBanLynxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressProvider()..load(),
      child: MaterialApp(
        title: 'qBank 2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.surface,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentCyan,
            secondary: AppColors.accentCyan,
            surface: AppColors.surface,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
