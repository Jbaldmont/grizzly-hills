import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/strings.dart';
import '../tag_statistics.dart';
import 'month_stepper.dart';
import 'scope_chips.dart';
import 'tag_breakdown_card.dart';
import 'tag_trend_card.dart';
import 'tag_trend_chart.dart';

const int _trendMonthCount = 6;

class TagStatisticsView extends StatefulWidget {
  const TagStatisticsView({
    super.key,
    required this.monthsNewestFirst,
    required this.tags,
    required this.statistics,
  });

  final List<Month> monthsNewestFirst;
  final List<ExpenseTag> tags;
  final TagStatistics statistics;

  @override
  State<TagStatisticsView> createState() => _TagStatisticsViewState();
}

class _TagStatisticsViewState extends State<TagStatisticsView> {
  int _monthIndex = 0;
  SpendingScope _scope = const SpendingScope.all();
  int? _trendTagId;

  Month get _selectedMonth => widget.monthsNewestFirst[_monthIndex];

  bool get _hasOlderMonth => _monthIndex < widget.monthsNewestFirst.length - 1;

  bool get _hasNewerMonth => _monthIndex > 0;

  @override
  Widget build(BuildContext context) {
    final month = _selectedMonth;
    final statistics = widget.statistics;
    final breakdown = statistics.tagBreakdown(month.id, _scope);
    final trendTagId =
        _trendTagId ??
        breakdown.firstOrNull?.tagId ??
        widget.tags.firstOrNull?.id;
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        MonthStepper(
          label: Strings.monthLabel(month.year, month.month),
          onPrevious: _hasOlderMonth ? () => _moveMonth(1) : null,
          onNext: _hasNewerMonth ? () => _moveMonth(-1) : null,
        ),
        const SizedBox(height: Dimens.spacingSm),
        ScopeChips(
          groupNames: statistics.groupNames,
          selected: _scope,
          onSelected: (scope) => setState(() => _scope = scope),
        ),
        const SizedBox(height: Dimens.spacingSm),
        TagBreakdownCard(
          breakdown: breakdown,
          untaggedCents: statistics.untaggedCents(month.id, _scope),
          totalCents: statistics.totalCents(month.id, _scope),
          tagNamesById: {for (final tag in widget.tags) tag.id: tag.name},
          selectedTagId: trendTagId,
          onTagTap: _selectTrendTag,
        ),
        const SizedBox(height: Dimens.spacingSm),
        TagTrendCard(
          tags: widget.tags,
          selectedTagId: trendTagId,
          onTagSelected: _selectTrendTag,
          points: trendTagId == null ? const [] : _trendPoints(trendTagId),
        ),
      ],
    );
  }

  List<TrendPoint> _trendPoints(int tagId) {
    final window = widget.monthsNewestFirst
        .skip(_monthIndex)
        .take(_trendMonthCount)
        .toList()
        .reversed;
    return [
      for (final month in window)
        TrendPoint(
          label: Strings.shortMonthLabel(month.month),
          amountCents: widget.statistics.tagCents(month.id, tagId, _scope),
          highlighted: month.id == _selectedMonth.id,
        ),
    ];
  }

  void _moveMonth(int offset) => setState(() => _monthIndex += offset);

  void _selectTrendTag(int tagId) => setState(() => _trendTagId = tagId);
}
