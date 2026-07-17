import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/app.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/core/strings.dart';
import 'package:grizzly_hills/core/theme/theme_controller.dart';
import 'package:grizzly_hills/features/expenses/expense_repository.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';
import 'package:grizzly_hills/features/savings/savings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GrizzlyApp> buildTestApp(AppDatabase db) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final themeController = await ThemeController.load();
  return GrizzlyApp(
    themeController: themeController,
    monthRepository: MonthRepository(db),
    expenseRepository: ExpenseRepository(db),
    savingsRepository: SavingsRepository(db),
  );
}

Future<void> disposeTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> openTestMonth(
  WidgetTester tester, {
  String salary = '3000',
}) async {
  await tester.tap(find.text(Strings.startMonthCta));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).first, salary);
  await tester.scrollUntilVisible(
    find.text(Strings.startMonthConfirm),
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.tap(find.text(Strings.startMonthConfirm));
  await tester.pumpAndSettle();
}
