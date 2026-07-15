import 'package:flutter/material.dart';

import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../../expenses/month_overview.dart';

class UnexpectedCard extends StatelessWidget {
  const UnexpectedCard({
    super.key,
    required this.overview,
    required this.onTap,
  });

  final MonthOverview overview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = overview.unexpectedExpenses.length;
    return Card(
      child: ListTile(
        leading: Icon(Icons.bolt_outlined, color: theme.colorScheme.tertiary),
        title: const Text(Strings.unexpectedSectionTitle),
        subtitle: Text(
          count == 0
              ? Strings.noExpensesYet
              : '$count ${count == 1 ? Strings.expenseSingular : Strings.expensePlural}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatBs(overview.unexpectedCents),
              style: theme.textTheme.titleMedium,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
