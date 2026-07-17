import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../home/widgets/group_card.dart';
import '../monthly_budget/month_repository.dart';
import 'expense_form_sheet.dart';
import 'expense_repository.dart';
import 'month_overview.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.monthId,
    required this.monthRepository,
    required this.expenseRepository,
    this.group,
  });

  final int monthId;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final BudgetGroup? group;

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late final Stream<List<Expense>> _expenses =
      widget.expenseRepository.watchExpenses(widget.monthId);

  ExpenseDestination get _destination => widget.group == null
      ? const ExpenseDestination.unexpected()
      : ExpenseDestination.group(widget.group!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group?.name ?? Strings.unexpectedSectionTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: Strings.quickExpenseTooltip,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildList(snapshot.data ?? []);
        },
      ),
    );
  }

  Widget _buildList(List<Expense> allExpenses) {
    final group = widget.group;
    final expenses = _filter(allExpenses);
    final totalCents =
        expenses.fold(0, (sum, expense) => sum + expense.amountCents);
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        if (group != null)
          GroupCard(
            group: group,
            spentCents: totalCents,
            extensionCents: MonthOverview.extensionCentsIn(
              allExpenses,
              group.id,
            ),
          )
        else
          _UnexpectedTotalCard(totalCents: totalCents),
        const SizedBox(height: Dimens.spacingSm),
        if (expenses.isEmpty)
          const _EmptyList()
        else
          for (final expense in expenses)
            if (expense.kind == ExpenseKind.budgetExtension)
              _ExpenseTile(expense: expense)
            else
              _ExpenseTile(
                expense: expense,
                onTap: () => _openForm(expenseToEdit: expense),
                onConfirmDelete: () =>
                    widget.expenseRepository.deleteExpense(expense.id),
              ),
      ],
    );
  }

  List<Expense> _filter(List<Expense> expenses) {
    final group = widget.group;
    return [
      for (final expense in expenses)
        if (group != null
            ? expense.kind == ExpenseKind.group && expense.groupId == group.id
            : expense.kind == ExpenseKind.unexpected ||
                expense.kind == ExpenseKind.budgetExtension)
          expense,
    ];
  }

  void _openForm({Expense? expenseToEdit}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExpenseFormSheet(
        monthId: widget.monthId,
        expenseRepository: widget.expenseRepository,
        monthRepository: widget.monthRepository,
        lockedDestination: _destination,
        expenseToEdit: expenseToEdit,
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({
    required this.expense,
    this.onTap,
    this.onConfirmDelete,
  });

  final Expense expense;
  final VoidCallback? onTap;
  final Future<void> Function()? onConfirmDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onConfirmDelete = this.onConfirmDelete;
    final tile = ListTile(
      contentPadding: EdgeInsets.zero,
      leading: onTap == null && onConfirmDelete == null
          ? const Icon(Icons.lock_outline)
          : null,
      title: Text(
        expense.description.isEmpty
            ? Strings.noDescription
            : expense.description,
      ),
      subtitle: Text(formatShortDate(expense.date)),
      trailing: Text(
        formatBs(expense.amountCents),
        style: theme.textTheme.titleMedium,
      ),
      onTap: onTap,
    );
    if (onConfirmDelete == null) {
      return tile;
    }
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Dimens.spacingMd),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete_outline,
            color: theme.colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onConfirmDelete(),
      child: tile,
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.deleteExpenseTitle),
        content: const Text(Strings.deleteExpenseBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.delete),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _UnexpectedTotalCard extends StatelessWidget {
  const _UnexpectedTotalCard({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Strings.unexpectedSectionTitle,
                style: theme.textTheme.titleMedium),
            Text(formatBs(totalCents), style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.spacingLg),
      child: Center(
        child: Text(
          Strings.noExpensesYet,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
