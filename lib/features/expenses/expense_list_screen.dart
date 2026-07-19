import 'dart:math';

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
import 'extension_request_dialog.dart';
import 'month_overview.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.month,
    required this.monthRepository,
    required this.expenseRepository,
    this.group,
  });

  final Month month;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final BudgetGroup? group;

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late final Stream<List<Expense>> _expenses =
      widget.expenseRepository.watchExpenses(widget.month.id);
  late final Stream<ActiveMonth?> _activeMonth =
      widget.monthRepository.watchActiveMonth();

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
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<Expense>>(
          stream: _expenses,
          builder: (context, expensesSnapshot) {
            if (expensesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allExpenses = expensesSnapshot.data ?? [];
            if (widget.group == null) {
              return _buildList(allExpenses);
            }
            return StreamBuilder<ActiveMonth?>(
              stream: _activeMonth,
              builder: (context, monthSnapshot) {
                final activeMonth = monthSnapshot.data;
                final availableGeneralCents = activeMonth == null
                    ? 0
                    : MonthOverview(
                        activeMonth: activeMonth,
                        expenses: allExpenses,
                      ).availableGeneralCents;
                return _buildList(
                  allExpenses,
                  availableGeneralCents: availableGeneralCents,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Expense> allExpenses, {int availableGeneralCents = 0}) {
    final group = widget.group;
    final expenses = _filter(allExpenses);
    final totalCents =
        expenses.fold(0, (sum, expense) => sum + expense.amountCents);
    final extensionCents = group == null
        ? 0
        : MonthOverview.extensionCentsIn(allExpenses, group.id);
    final returnableCents = group == null
        ? 0
        : max<int>(0, extensionCents - max<int>(0, totalCents - group.budgetCents));
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        if (group != null) ...[
          GroupCard(
            group: group,
            spentCents: totalCents,
            extensionCents: extensionCents,
          ),
          const SizedBox(height: Dimens.spacingSm),
          OutlinedButton.icon(
            onPressed: availableGeneralCents > 0
                ? () => _requestExtension(group, availableGeneralCents)
                : null,
            icon: const Icon(Icons.add),
            label: const Text(Strings.requestExtension),
          ),
          if (extensionCents > 0)
            OutlinedButton.icon(
              onPressed: returnableCents > 0
                  ? () => _returnExtension(group, returnableCents)
                  : null,
              icon: const Icon(Icons.undo),
              label: const Text(Strings.returnExtension),
            ),
        ] else
          _UnexpectedTotalCard(totalCents: totalCents),
        const SizedBox(height: Dimens.spacingSm),
        if (expenses.isEmpty)
          const _EmptyList()
        else
          for (final expense in expenses)
            if (_isLocked(expense))
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
            ? MonthOverview.countsAsGroupSpending(expense) &&
                expense.groupId == group.id
            : expense.kind == ExpenseKind.unexpected ||
                expense.kind == ExpenseKind.budgetExtension)
          expense,
    ];
  }

  bool _isLocked(Expense expense) =>
      expense.kind == ExpenseKind.budgetExtension ||
      expense.kind == ExpenseKind.savingsTransfer;

  Future<void> _requestExtension(
    BudgetGroup group,
    int availableGeneralCents,
  ) async {
    final amountCents = await showDialog<int>(
      context: context,
      builder: (_) => ExtensionAmountDialog(
        title: Strings.requestExtension,
        limitLabel: Strings.availableGeneralRowLabel,
        limitCents: availableGeneralCents,
        confirmLabel: Strings.request,
        exceedsLimitError: Strings.extensionExceedsGeneralError,
      ),
    );
    if (amountCents == null) {
      return;
    }
    await widget.expenseRepository.addExpense(
      monthId: widget.month.id,
      kind: ExpenseKind.budgetExtension,
      groupId: group.id,
      description: Strings.extensionDescription(group.name),
      amountCents: amountCents,
      date: dateOnly(DateTime.now()),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.extensionAppliedMessage)),
      );
    }
  }

  Future<void> _returnExtension(
    BudgetGroup group,
    int returnableCents,
  ) async {
    final amountCents = await showDialog<int>(
      context: context,
      builder: (_) => ExtensionAmountDialog(
        title: Strings.returnExtension,
        limitLabel: Strings.returnableExtensionLabel,
        limitCents: returnableCents,
        confirmLabel: Strings.returnConfirm,
        exceedsLimitError: Strings.extensionReturnExceedsError,
      ),
    );
    if (amountCents == null) {
      return;
    }
    await widget.expenseRepository.returnExtension(
      groupId: group.id,
      amountCents: amountCents,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.extensionReturnedMessage)),
      );
    }
  }

  void _openForm({Expense? expenseToEdit}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExpenseFormSheet(
        month: widget.month,
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
