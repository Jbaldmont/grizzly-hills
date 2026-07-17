import 'package:flutter/material.dart';

import '../../../core/dates.dart';
import '../../../core/db/app_database.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../loan_interest.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({super.key, required this.loan, required this.onTap});

  final Loan loan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final overdue = isOverdue(loan, today);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.handshake_outlined),
        title: Text(loan.debtorName),
        subtitle: Text(
          overdue
              ? '${Strings.overdueLabel} · '
                    '${Strings.dueLabel.toLowerCase()} '
                    '${formatShortDate(loan.dueDate)}'
              : '${Strings.dueLabel} ${formatShortDate(loan.dueDate)}',
          style: overdue
              ? theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                )
              : theme.textTheme.bodySmall,
        ),
        trailing: Text(
          formatBs(totalOwedCents(loan, today)),
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}
