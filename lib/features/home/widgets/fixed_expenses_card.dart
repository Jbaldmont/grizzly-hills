import 'package:flutter/material.dart';

import '../../../core/dates.dart';
import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../../expenses/expense_repository.dart';
import '../../expenses/month_overview.dart';

class FixedExpensesCard extends StatefulWidget {
  const FixedExpensesCard({
    super.key,
    required this.overview,
    required this.expenseRepository,
  });

  final MonthOverview overview;
  final ExpenseRepository expenseRepository;

  @override
  State<FixedExpensesCard> createState() => _FixedExpensesCardState();
}

class _FixedExpensesCardState extends State<FixedExpensesCard> {
  late final Stream<List<FixedExpenseTemplate>> _templates =
      widget.expenseRepository.watchFixedTemplates();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spacingSm),
        child: StreamBuilder<List<FixedExpenseTemplate>>(
          stream: _templates,
          builder: (context, snapshot) {
            final templates = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingMd,
                    vertical: Dimens.spacingXs,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Strings.fixedSectionTitle,
                          style: theme.textTheme.titleMedium),
                      Text(formatBs(widget.overview.fixedCents),
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                for (final template in templates)
                  _FixedTile(
                    template: template,
                    paidExpense: _paidExpenseFor(template),
                    onPay: () => _showPayDialog(template),
                    onUnmark: (expense) => _confirmUnmark(expense),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Expense? _paidExpenseFor(FixedExpenseTemplate template) {
    for (final expense in widget.overview.fixedExpenses) {
      if (expense.fixedTemplateId == template.id) {
        return expense;
      }
    }
    return null;
  }

  Future<void> _showPayDialog(FixedExpenseTemplate template) async {
    final amountCents = await showDialog<int>(
      context: context,
      builder: (_) => _PayFixedDialog(template: template),
    );
    if (amountCents == null) {
      return;
    }
    await widget.expenseRepository.addExpense(
      monthId: widget.overview.activeMonth.month.id,
      kind: ExpenseKind.fixed,
      description: template.name,
      amountCents: amountCents,
      date: dateOnly(DateTime.now()),
      fixedTemplateId: template.id,
    );
  }

  Future<void> _confirmUnmark(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.unmarkFixedTitle),
        content: const Text(Strings.unmarkFixedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.remove),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await widget.expenseRepository.deleteExpense(expense.id);
    }
  }
}

class _FixedTile extends StatelessWidget {
  const _FixedTile({
    required this.template,
    required this.paidExpense,
    required this.onPay,
    required this.onUnmark,
  });

  final FixedExpenseTemplate template;
  final Expense? paidExpense;
  final VoidCallback onPay;
  final ValueChanged<Expense> onUnmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expense = paidExpense;
    final isPaid = expense != null;
    return ListTile(
      dense: true,
      leading: Icon(
        isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isPaid ? theme.colorScheme.primary : theme.colorScheme.outline,
      ),
      title: Text(template.name),
      subtitle: isPaid ? Text(formatShortDate(expense.date)) : null,
      trailing: Text(
        isPaid
            ? formatBs(expense.amountCents)
            : template.lastAmountCents > 0
                ? formatBs(template.lastAmountCents)
                : '',
        style: isPaid
            ? theme.textTheme.titleSmall
            : theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
      onTap: isPaid ? () => onUnmark(expense) : onPay,
    );
  }
}

class _PayFixedDialog extends StatefulWidget {
  const _PayFixedDialog({required this.template});

  final FixedExpenseTemplate template;

  @override
  State<_PayFixedDialog> createState() => _PayFixedDialogState();
}

class _PayFixedDialogState extends State<_PayFixedDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController = TextEditingController(
    text: widget.template.lastAmountCents > 0
        ? centsToEditableText(widget.template.lastAmountCents)
        : '',
  );

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template.name),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: Strings.markFixedAmountLabel,
            prefixText: '${Strings.currency} ',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            final cents = parseBsToCents(value ?? '');
            return cents == null || cents <= 0
                ? Strings.invalidAmountError
                : null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text(Strings.pay),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(parseBsToCents(_amountController.text));
  }
}
