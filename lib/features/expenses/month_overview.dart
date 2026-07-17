import '../../core/db/app_database.dart';
import '../monthly_budget/month_repository.dart';

class MonthOverview {
  const MonthOverview({required this.activeMonth, required this.expenses});

  final ActiveMonth activeMonth;
  final List<Expense> expenses;

  int spentInGroupCents(int groupId) => _sum(
        expenses.where(
          (expense) =>
              expense.kind == ExpenseKind.group && expense.groupId == groupId,
        ),
      );

  static int extensionCentsIn(List<Expense> expenses, int groupId) =>
      expenses.fold(0, (sum, expense) {
        final isGroupExtension =
            expense.kind == ExpenseKind.budgetExtension &&
            expense.groupId == groupId;
        return isGroupExtension ? sum + expense.amountCents : sum;
      });

  int extensionCentsForGroup(int groupId) =>
      extensionCentsIn(expenses, groupId);

  List<Expense> get fixedExpenses => [
        for (final expense in expenses)
          if (expense.kind == ExpenseKind.fixed) expense,
      ];

  List<Expense> get unexpectedExpenses => [
        for (final expense in expenses)
          if (expense.kind == ExpenseKind.unexpected ||
              expense.kind == ExpenseKind.budgetExtension)
            expense,
      ];

  int get fixedCents => _sum(fixedExpenses);

  int get unexpectedCents => _sum(unexpectedExpenses);

  int get availableGeneralCents =>
      activeMonth.generalBudgetCents - fixedCents - unexpectedCents;

  int _sum(Iterable<Expense> items) =>
      items.fold(0, (sum, expense) => sum + expense.amountCents);
}
