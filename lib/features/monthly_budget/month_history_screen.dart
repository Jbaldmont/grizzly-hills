import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../expenses/expense_repository.dart';
import '../savings/savings_repository.dart';
import 'month_detail_screen.dart';
import 'month_repository.dart';

class MonthHistoryScreen extends StatefulWidget {
  const MonthHistoryScreen({
    super.key,
    required this.monthRepository,
    required this.expenseRepository,
    required this.savingsRepository,
  });

  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final SavingsRepository savingsRepository;

  @override
  State<MonthHistoryScreen> createState() => _MonthHistoryScreenState();
}

class _MonthHistoryScreenState extends State<MonthHistoryScreen> {
  late final Stream<List<Month>> _closedMonths = widget.monthRepository
      .watchClosedMonths();
  late final Stream<List<SavingsLocation>> _locations = widget
      .savingsRepository
      .watchLocations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.monthHistoryTitle)),
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<Month>>(
          stream: _closedMonths,
          builder: (context, monthsSnapshot) {
            if (monthsSnapshot.hasError) {
              return const ErrorState();
            }
            if (monthsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final months = monthsSnapshot.data ?? [];
            if (months.isEmpty) {
              return const _EmptyHistory();
            }
            return StreamBuilder<List<SavingsLocation>>(
              stream: _locations,
              builder: (context, locationsSnapshot) {
                final locationNames = {
                  for (final location in locationsSnapshot.data ?? const [])
                    location.id: location.name,
                };
                return ListView(
                  padding: const EdgeInsets.all(Dimens.spacingMd),
                  children: [
                    for (final month in months)
                      _ClosedMonthTile(
                        month: month,
                        locationName: locationNames[month.closingSavingsLocationId],
                        onTap: () => _openDetail(month),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _openDetail(Month month) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MonthDetailScreen(
          month: month,
          monthRepository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
        ),
      ),
    );
  }
}

class _ClosedMonthTile extends StatelessWidget {
  const _ClosedMonthTile({
    required this.month,
    required this.locationName,
    required this.onTap,
  });

  final Month month;
  final String? locationName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transferCents = month.closingTransferCents ?? 0;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.event_available_outlined),
        title: Text(Strings.monthLabel(month.year, month.month)),
        subtitle: Text(_subtitle(transferCents)),
        trailing: Text(
          _trailing(transferCents),
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }

  String _subtitle(int transferCents) {
    final closedLabel =
        '${Strings.closedOnLabel} ${formatShortDate(month.closedAt!)}';
    final location = locationName;
    if (transferCents > 0 && location != null) {
      return '$closedLabel · ${Strings.closingTransferredTo(location)}';
    }
    return closedLabel;
  }

  String _trailing(int transferCents) {
    if (transferCents > 0) {
      return formatBs(transferCents);
    }
    if (transferCents == 0) {
      return Strings.closingNoSurplusLabel;
    }
    return Strings.closingDeficitLabel(formatBs(-transferCents));
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

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
              Icons.history,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(
              Strings.monthHistoryEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
