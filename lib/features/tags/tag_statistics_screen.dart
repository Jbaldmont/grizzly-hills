import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../monthly_budget/month_repository.dart';
import 'tag_repository.dart';
import 'tag_statistics.dart';
import 'widgets/tag_statistics_view.dart';

typedef _StatisticsData = ({
  List<Month> months,
  List<ExpenseTag> tags,
  TagStatistics statistics,
});

class TagStatisticsScreen extends StatefulWidget {
  const TagStatisticsScreen({
    super.key,
    required this.monthRepository,
    required this.tagRepository,
  });

  final MonthRepository monthRepository;
  final TagRepository tagRepository;

  @override
  State<TagStatisticsScreen> createState() => _TagStatisticsScreenState();
}

class _TagStatisticsScreenState extends State<TagStatisticsScreen> {
  late final Future<_StatisticsData> _data = _load();

  Future<_StatisticsData> _load() async {
    final months = await widget.monthRepository.loadAllMonths();
    final tags = await widget.tagRepository.loadTags();
    final entries = await widget.tagRepository.loadSpendingEntries();
    return (months: months, tags: tags, statistics: TagStatistics(entries));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.tagStatisticsTitle)),
      body: SafeArea(
        top: false,
        child: FutureBuilder<_StatisticsData>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorState();
            }
            final data = snapshot.data;
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (data.months.isEmpty) {
              return const _EmptyStatistics();
            }
            return TagStatisticsView(
              monthsNewestFirst: data.months,
              tags: data.tags,
              statistics: data.statistics,
            );
          },
        ),
      ),
    );
  }
}

class _EmptyStatistics extends StatelessWidget {
  const _EmptyStatistics();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(
              Strings.tagStatisticsEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.tagStatisticsEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
