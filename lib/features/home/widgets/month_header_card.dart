import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import '../../../core/strings.dart';
import '../../../core/widgets/amount_row.dart';
import '../../expenses/month_overview.dart';

class MonthHeaderCard extends StatelessWidget {
  const MonthHeaderCard({
    super.key,
    required this.overview,
    required this.onEdit,
  });

  final MonthOverview overview;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final month = overview.activeMonth.month;
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
            AmountRow(
              label: Strings.salaryRowLabel,
              amountCents: month.salaryCents,
            ),
            AmountRow(
              label: Strings.assignedRowLabel,
              amountCents: overview.activeMonth.assignedCents,
            ),
            AmountRow(
              label: Strings.generalBudgetRowLabel,
              amountCents: overview.activeMonth.generalBudgetCents,
            ),
            AmountRow(
              label: Strings.fixedPaidRowLabel,
              amountCents: -overview.fixedCents,
            ),
            AmountRow(
              label: Strings.unexpectedRowLabel,
              amountCents: -overview.unexpectedCents,
            ),
            const Divider(),
            AmountRow(
              label: Strings.availableGeneralRowLabel,
              amountCents: overview.availableGeneralCents,
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}
