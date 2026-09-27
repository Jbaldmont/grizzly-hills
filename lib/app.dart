import 'package:flutter/material.dart';
import 'core/security/app_lock_gate.dart';
import 'core/security/lock_controller.dart';
import 'core/strings.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'features/expenses/expense_repository.dart';
import 'features/loans/loan_repository.dart';
import 'features/monthly_budget/month_repository.dart';
import 'features/savings/savings_repository.dart';
import 'shell/app_shell.dart';

class GrizzlyApp extends StatelessWidget {
  const GrizzlyApp({
    super.key,
    required this.themeController,
    required this.lockController,
    required this.monthRepository,
    required this.expenseRepository,
    required this.savingsRepository,
    required this.loanRepository,
  });

  final ThemeController themeController;
  final LockController lockController;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final SavingsRepository savingsRepository;
  final LoanRepository loanRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: Strings.appTitle,
        theme: buildLightTheme(themeController.scheme),
        darkTheme: buildDarkTheme(themeController.scheme),
        themeMode: themeController.mode,
        home: AppLockGate(
          lockController: lockController,
          child: AppShell(
            themeController: themeController,
            lockController: lockController,
            monthRepository: monthRepository,
            expenseRepository: expenseRepository,
            savingsRepository: savingsRepository,
            loanRepository: loanRepository,
          ),
        ),
      ),
    );
  }
}
