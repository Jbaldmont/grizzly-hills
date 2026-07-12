import 'package:flutter/material.dart';
import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../../monthly_budget/month_repository.dart';

class MonthHeaderCard extends StatelessWidget {
  const MonthHeaderCard({
    super.key,
    required this.activeMonth,
    required this.onEdit,
  });

  final ActiveMonth activeMonth;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final month = activeMonth.month;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.monthLabel(month.year, month.month),
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: Strings.editMonthTooltip,
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingSm),
            _AmountRow(
              label: Strings.salaryRowLabel,
              amountCents: month.salaryCents,
            ),
            _AmountRow(
              label: Strings.assignedRowLabel,
              amountCents: activeMonth.assignedCents,
            ),
            const Divider(),
            _AmountRow(
              label: Strings.generalBudgetRowLabel,
              amountCents: activeMonth.generalBudgetCents,
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amountCents,
    this.emphasized = false,
  });

  final String label;
  final int amountCents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(
            color: amountCents < 0
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatBs(amountCents), style: style),
        ],
      ),
    );
  }
}
