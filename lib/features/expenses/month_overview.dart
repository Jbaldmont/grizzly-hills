import '../../core/db/app_database.dart';
import '../monthly_budget/month_repository.dart';

class MonthOverview {
  const MonthOverview({required this.activeMonth, required this.expenses});

  final ActiveMonth activeMonth;
  final List<Expense> expenses;

  int spentInGroupCents(int groupId) => _sum(
        expenses.where((expense) => expense.groupId == groupId),
      );

  List<Expense> get fixedExpenses =>
      [for (final e in expenses) if (e.kind == ExpenseKind.fixed) e];

  List<Expense> get unexpectedExpenses =>
      [for (final e in expenses) if (e.kind == ExpenseKind.unexpected) e];

  int get fixedCents => _sum(fixedExpenses);

  int get unexpectedCents => _sum(unexpectedExpenses);

  int get availableGeneralCents =>
      activeMonth.generalBudgetCents - fixedCents - unexpectedCents;

  int _sum(Iterable<Expense> items) =>
      items.fold(0, (sum, expense) => sum + expense.amountCents);
}
