import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_constants.dart';
import 'config/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SprintAiApp());
}

class SprintAiApp extends StatelessWidget {
  const SprintAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
