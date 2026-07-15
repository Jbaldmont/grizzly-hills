import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.spentCents = 0,
    this.onTap,
  });

  final BudgetGroup group;
  final int spentCents;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio =
        group.budgetCents == 0 ? 0.0 : spentCents / group.budgetCents;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                        Text(group.name, style: theme.textTheme.titleMedium),
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
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: Dimens.progressBarHeight,
                  color: _progressColor(theme.colorScheme, ratio),
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Strings.spentLabel}: ${formatBs(spentCents)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    '${Strings.remainingLabel} '
                    '${formatBs(group.budgetCents - spentCents)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: spentCents > group.budgetCents
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _progressColor(ColorScheme scheme, double ratio) {
    if (ratio >= 0.9) {
      return scheme.error;
    }
    if (ratio >= 0.75) {
      return scheme.tertiary;
    }
    return scheme.primary;
  }
}
