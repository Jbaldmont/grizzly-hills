import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/strings.dart';
import 'tag_trend_chart.dart';

class TagTrendCard extends StatelessWidget {
  const TagTrendCard({
    super.key,
    required this.tags,
    required this.points,
    required this.onTagSelected,
    this.selectedTagId,
  });

  final List<ExpenseTag> tags;
  final List<TrendPoint> points;
  final ValueChanged<int> onTagSelected;
  final int? selectedTagId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final hasSpending = points.any((point) => point.amountCents > 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.tagTrendTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: Dimens.spacingSm),
            if (selectedTagId == null)
              Text(Strings.noTagsForTrend, style: mutedStyle)
            else ...[
              _buildTagChips(),
              const SizedBox(height: Dimens.spacingMd),
              if (hasSpending)
                TagTrendChart(points: points)
              else
                Text(Strings.noTagSpendingInWindow, style: mutedStyle),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTagChips() {
    return Wrap(
      spacing: Dimens.spacingSm,
      runSpacing: Dimens.spacingXs,
      children: [
        for (final tag in tags)
          ChoiceChip(
            label: Text(tag.name),
            selected: tag.id == selectedTagId,
            onSelected: (_) => onTagSelected(tag.id),
          ),
      ],
    );
  }
}
