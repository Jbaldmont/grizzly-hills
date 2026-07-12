import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.group, this.spentCents = 0});

  final BudgetGroup group;

  final int spentCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = group.budgetCents == 0
        ? 0.0
        : (spentCents / group.budgetCents).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(group.name, style: theme.textTheme.titleMedium),
                ),
                Text(
                  formatBs(group.budgetCents),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.radiusSm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: Dimens.progressBarHeight,
              ),
            ),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              '${Strings.spentLabel}: ${formatBs(spentCents)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
