import 'package:flutter/material.dart';
import 'app.dart';
import 'core/db/app_database.dart';
import 'core/notifications/notification_service.dart';
import 'core/theme/theme_controller.dart';
import 'features/expenses/expense_repository.dart';
import 'features/loans/loan_repository.dart';
import 'features/monthly_budget/month_repository.dart';
import 'features/savings/savings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.load();
  final database = AppDatabase();
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();

  final monthRepository = MonthRepository(database, notificationService);
  final expenseRepository = ExpenseRepository(database, notificationService);
  final loanRepository = LoanRepository(database, notificationService);
  final savingsRepository = SavingsRepository(database);
  await notificationService.syncScheduledReminders(
    monthRepository: monthRepository,
    loanRepository: loanRepository,
  );

  runApp(
    GrizzlyApp(
      themeController: themeController,
      monthRepository: monthRepository,
      expenseRepository: expenseRepository,
      savingsRepository: savingsRepository,
      loanRepository: loanRepository,
    ),
  );
}
