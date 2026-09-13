import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../../../core/theme/progress_colors.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.spentCents = 0,
    this.extensionCents = 0,
    this.onTap,
  });

  final BudgetGroup group;
  final int spentCents;
  final int extensionCents;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBudgetCents = group.budgetCents + extensionCents;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                        Text(group.name, style: theme.textTheme.titleMedium),
                  ),
                  if (extensionCents == 0)
                    Text(
                      formatBs(group.budgetCents),
                      style: theme.textTheme.titleMedium,
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatBs(effectiveBudgetCents),
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          Strings.budgetWithExtension(
                            formatBs(group.budgetCents),
                            formatBs(extensionCents),
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: Dimens.spacingSm),
              _GroupProgressBar(
                budgetCents: group.budgetCents,
                extensionCents: extensionCents,
                spentCents: spentCents,
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
                    '${formatBs(effectiveBudgetCents - spentCents)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: spentCents > effectiveBudgetCents
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

}

class _GroupProgressBar extends StatelessWidget {
  const _GroupProgressBar({
    required this.budgetCents,
    required this.extensionCents,
    required this.spentCents,
  });

  final int budgetCents;
  final int extensionCents;
  final int spentCents;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBudgetCents = budgetCents + extensionCents;
    final ratio = effectiveBudgetCents == 0
        ? 0.0
        : spentCents / effectiveBudgetCents;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radiusSm),
      child: extensionCents == 0
          ? LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: Dimens.progressBarHeight,
              color: ProgressColors.forRatio(ratio),
            )
          : _buildSegmentedBar(colorScheme, ratio),
    );
  }

  double get _baseRatio =>
      budgetCents == 0 ? 0.0 : min(spentCents, budgetCents) / budgetCents;

  double get _extensionRatio => extensionCents == 0
      ? 0.0
      : max(0, spentCents - budgetCents) / extensionCents;

  Widget _buildSegmentedBar(ColorScheme colorScheme, double ratio) {
    return SizedBox(
      height: Dimens.progressBarHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final effectiveBudgetCents = budgetCents + extensionCents;
          final baseFraction = budgetCents / effectiveBudgetCents;
          final spentFraction = ratio.clamp(0.0, 1.0);
          final markerStart = barWidth * baseFraction;
          final baseFillWidth = barWidth * min(spentFraction, baseFraction);
          final extensionFillWidth =
              barWidth * max(0.0, spentFraction - baseFraction);
          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: colorScheme.surfaceContainerHighest),
              ),
              Positioned(
                left: markerStart,
                right: 0,
                top: 0,
                bottom: 0,
                child: ColoredBox(color: colorScheme.tertiaryContainer),
              ),
              Positioned(
                left: 0,
                width: baseFillWidth,
                top: 0,
                bottom: 0,
                child: ColoredBox(color: ProgressColors.forRatio(_baseRatio)),
              ),
              Positioned(
                left: markerStart,
                width: extensionFillWidth,
                top: 0,
                bottom: 0,
                child: ColoredBox(
                  color: ProgressColors.forRatio(_extensionRatio),
                ),
              ),
              Positioned(
                left: markerStart - Dimens.progressMarkerWidth / 2,
                width: Dimens.progressMarkerWidth,
                top: 0,
                bottom: 0,
                child: ColoredBox(color: colorScheme.outline),
              ),
            ],
          );
        },
      ),
    );
  }

}
