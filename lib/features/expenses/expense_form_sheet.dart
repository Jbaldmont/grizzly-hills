import 'package:flutter/material.dart';
import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/date_field.dart';
import '../monthly_budget/month_repository.dart';
import 'expense_repository.dart';
import 'month_overview.dart';

enum _InsufficientBudgetAction { cancel, requestExtension, continueAnyway }

class ExpenseDestination {
  const ExpenseDestination.group(BudgetGroup this.group);

  const ExpenseDestination.unexpected() : group = null;

  final BudgetGroup? group;

  String get label => group?.name ?? Strings.unexpectedLabel;

  ExpenseKind get kind =>
      group == null ? ExpenseKind.unexpected : ExpenseKind.group;
}

void showQuickExpenseSheet(
  BuildContext context, {
  required ActiveMonth activeMonth,
  required ExpenseRepository expenseRepository,
  required MonthRepository monthRepository,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => ExpenseFormSheet(
      monthId: activeMonth.month.id,
      expenseRepository: expenseRepository,
      monthRepository: monthRepository,
      destinations: [
        for (final group in activeMonth.groups) ExpenseDestination.group(group),
        const ExpenseDestination.unexpected(),
      ],
    ),
  );
}

class ExpenseFormSheet extends StatefulWidget {
  const ExpenseFormSheet({
    super.key,
    required this.monthId,
    required this.expenseRepository,
    required this.monthRepository,
    this.destinations = const [],
    this.lockedDestination,
    this.expenseToEdit,
  });

  final int monthId;
  final ExpenseRepository expenseRepository;
  final MonthRepository monthRepository;
  final List<ExpenseDestination> destinations;
  final ExpenseDestination? lockedDestination;
  final Expense? expenseToEdit;

  @override
  State<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late DateTime _date;
  ExpenseDestination? _destination;
  bool _saving = false;
  bool _destinationMissing = false;

  bool get _isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expenseToEdit;
    _amountController = TextEditingController(
      text: expense == null ? '' : centsToEditableText(expense.amountCents),
    );
    _descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    _date = dateOnly(expense?.date ?? DateTime.now());
    _destination = widget.lockedDestination;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.spacingMd,
        right: Dimens.spacingMd,
        top: Dimens.spacingMd,
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.spacingMd,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? Strings.editExpenseTitle : Strings.newExpenseTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: Strings.amountLabel,
                prefixText: '${Strings.currency} ',
                border: OutlineInputBorder(),
              ),
              validator: _validateAmount,
            ),
            if (widget.lockedDestination == null) ...[
              const SizedBox(height: Dimens.spacingMd),
              _buildDestinationChips(theme),
            ],
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: Strings.descriptionLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Dimens.spacingSm),
            DateField(
              label: Strings.dateLabel,
              date: _date,
              onChanged: (value) {
                setState(() => _date = value);
              },
            ),
            const SizedBox(height: Dimens.spacingMd),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text(Strings.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationChips(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.destinationLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: Dimens.spacingSm),
        Wrap(
          spacing: Dimens.spacingSm,
          runSpacing: Dimens.spacingXs,
          children: [
            for (final destination in widget.destinations)
              ChoiceChip(
                label: Text(destination.label),
                selected: identical(_destination, destination),
                onSelected: (_) => setState(() {
                  _destination = destination;
                  _destinationMissing = false;
                }),
              ),
          ],
        ),
        if (_destinationMissing) ...[
          const SizedBox(height: Dimens.spacingXs),
          Text(
            Strings.destinationRequiredError,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    return null;
  }

  Future<void> _save() async {
    final destination = _destination;
    final amountValid = _formKey.currentState!.validate();
    if (destination == null) {
      setState(() => _destinationMissing = true);
      return;
    }
    if (!amountValid) {
      return;
    }
    final group = destination.group;
    if (group != null) {
      final amountCents = parseBsToCents(_amountController.text)!;
      final proceed = await _ensureGroupBudget(group, amountCents);
      if (!proceed || !mounted) {
        return;
      }
    }
    setState(() => _saving = true);
    try {
      await _persist(destination);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }

  Future<bool> _ensureGroupBudget(BudgetGroup group, int amountCents) async {
    final expenses = await widget.expenseRepository.loadExpenses(
      widget.monthId,
    );
    final excludedId = widget.expenseToEdit?.id;
    final spentOthers = expenses.fold<int>(0, (sum, expense) {
      final sameGroup = expense.groupId == group.id;
      final isEditedExpense = excludedId != null && expense.id == excludedId;
      return sameGroup && !isEditedExpense ? sum + expense.amountCents : sum;
    });
    final remainingCents = group.budgetCents - spentOthers;
    final shortfallCents = amountCents - remainingCents;
    if (shortfallCents <= 0) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    final activeMonth = await widget.monthRepository.loadActiveMonth(
      widget.monthId,
    );
    if (activeMonth == null) {
      return true;
    }
    final overview = MonthOverview(
      activeMonth: activeMonth,
      expenses: expenses,
    );
    if (!mounted) {
      return false;
    }
    return _resolveInsufficientBudget(
      group: group,
      remainingCents: remainingCents,
      shortfallCents: shortfallCents,
      availableGeneralCents: overview.availableGeneralCents,
    );
  }

  Future<bool> _resolveInsufficientBudget({
    required BudgetGroup group,
    required int remainingCents,
    required int shortfallCents,
    required int availableGeneralCents,
  }) async {
    final canExtend = availableGeneralCents >= shortfallCents;
    final action = await showDialog<_InsufficientBudgetAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.insufficientBudgetTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(Strings.insufficientBudgetExplanation),
            const SizedBox(height: Dimens.spacingSm),
            _AmountRow(
              label: '${Strings.remainingLabel} ${group.name}',
              amountCents: remainingCents,
            ),
            _AmountRow(
              label: Strings.shortfallLabel,
              amountCents: shortfallCents,
            ),
            _AmountRow(
              label: Strings.availableGeneralRowLabel,
              amountCents: availableGeneralCents,
            ),
            if (!canExtend) ...[
              const SizedBox(height: Dimens.spacingSm),
              Text(
                Strings.generalBudgetAlsoInsufficient,
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              dialogContext,
            ).pop(_InsufficientBudgetAction.cancel),
            child: const Text(Strings.cancel),
          ),
          if (canExtend)
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_InsufficientBudgetAction.requestExtension),
              child: const Text(Strings.requestExtension),
            )
          else
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_InsufficientBudgetAction.continueAnyway),
              child: const Text(Strings.continueAnyway),
            ),
        ],
      ),
    );
    if (action == _InsufficientBudgetAction.requestExtension) {
      await widget.monthRepository.transferFromGeneralToGroup(
        groupId: group.id,
        amountCents: shortfallCents,
      );
      return true;
    }
    return action == _InsufficientBudgetAction.continueAnyway;
  }

  Future<void> _persist(ExpenseDestination destination) {
    final amountCents = parseBsToCents(_amountController.text)!;
    final description = _descriptionController.text.trim();
    final expense = widget.expenseToEdit;
    if (expense != null) {
      return widget.expenseRepository.updateExpense(
        id: expense.id,
        description: description,
        amountCents: amountCents,
        date: _date,
      );
    }
    return widget.expenseRepository.addExpense(
      monthId: widget.monthId,
      kind: destination.kind,
      groupId: destination.group?.id,
      description: description,
      amountCents: amountCents,
      date: _date,
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.amountCents});

  final String label;
  final int amountCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            formatBs(amountCents),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
