import 'package:flutter/material.dart';
import 'core/strings.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'features/expenses/expense_repository.dart';
import 'features/monthly_budget/month_repository.dart';
import 'shell/app_shell.dart';

class GrizzlyApp extends StatelessWidget {
  const GrizzlyApp({
    super.key,
    required this.themeController,
    required this.monthRepository,
    required this.expenseRepository,
  });

  final ThemeController themeController;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: Strings.appTitle,
        theme: buildLightTheme(themeController.scheme),
        darkTheme: buildDarkTheme(themeController.scheme),
        themeMode: themeController.mode,
        home: AppShell(
          themeController: themeController,
          monthRepository: monthRepository,
          expenseRepository: expenseRepository,
        ),
      ),
    );
  }
}
