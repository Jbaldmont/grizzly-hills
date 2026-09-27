import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';
import '../tag_statistics.dart';

class TagBreakdownCard extends StatelessWidget {
  const TagBreakdownCard({
    super.key,
    required this.breakdown,
    required this.untaggedCents,
    required this.totalCents,
    required this.tagNamesById,
    required this.onTagTap,
    this.selectedTagId,
  });

  final List<TagAmount> breakdown;
  final int untaggedCents;
  final int totalCents;
  final Map<int, String> tagNamesById;
  final ValueChanged<int> onTagTap;
  final int? selectedTagId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.tagBreakdownTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: Dimens.spacingSm),
            if (totalCents == 0)
              Text(
                Strings.noSpendingInScope,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else ...[
              for (final item in breakdown)
                _BreakdownRow(
                  label: tagNamesById[item.tagId] ?? '',
                  amountCents: item.amountCents,
                  totalCents: totalCents,
                  barColor: theme.colorScheme.primary,
                  selected: item.tagId == selectedTagId,
                  onTap: () => onTagTap(item.tagId),
                ),
              if (untaggedCents > 0)
                _BreakdownRow(
                  label: Strings.untaggedLabel,
                  amountCents: untaggedCents,
                  totalCents: totalCents,
                  barColor: theme.colorScheme.outline,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.amountCents,
    required this.totalCents,
    required this.barColor,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final int amountCents;
  final int totalCents;
  final Color barColor;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final share = amountCents / totalCents;
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: selected ? FontWeight.bold : null,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(label, style: labelStyle)),
                const SizedBox(width: Dimens.spacingSm),
                Text(
                  Strings.amountWithShare(
                    formatBs(amountCents),
                    formatPercent((share * 100).roundToDouble()),
                  ),
                  style: labelStyle,
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingXs),
            _ShareBar(share: share, color: barColor),
          ],
        ),
      ),
    );
  }
}

class _ShareBar extends StatelessWidget {
  const _ShareBar({required this.share, required this.color});

  final double share;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radiusSm),
      child: SizedBox(
        height: Dimens.progressBarHeight,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: share.clamp(0, 1),
            child: ColoredBox(color: color),
          ),
        ),
      ),
    );
  }
}
