import 'package:flutter/material.dart';
import 'app.dart';
import 'core/db/app_database.dart';
import 'core/theme/theme_controller.dart';
import 'features/expenses/expense_repository.dart';
import 'features/loans/loan_repository.dart';
import 'features/monthly_budget/month_repository.dart';
import 'features/savings/savings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.load();
  final database = AppDatabase();
  runApp(
    GrizzlyApp(
      themeController: themeController,
      monthRepository: MonthRepository(database),
      expenseRepository: ExpenseRepository(database),
      savingsRepository: SavingsRepository(database),
      loanRepository: LoanRepository(database),
    ),
  );
}
