import 'package:flutter/material.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../monthly_budget/month_repository.dart';
import '../monthly_budget/start_month_screen.dart';
import 'widgets/group_card.dart';
import 'widgets/month_header_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final MonthRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<ActiveMonth?> _activeMonth = widget.repository
      .watchActiveMonth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ActiveMonth?>(
      stream: _activeMonth,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _ErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final activeMonth = snapshot.data;
        if (activeMonth == null) {
          return _EmptyState(onStartMonth: _openStartMonth);
        }
        return _MonthSummary(
          activeMonth: activeMonth,
          onEdit: () => _openEditMonth(activeMonth),
        );
      },
    );
  }

  void _openStartMonth() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StartMonthScreen(repository: widget.repository),
      ),
    );
  }

  void _openEditMonth(ActiveMonth activeMonth) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StartMonthScreen(
          repository: widget.repository,
          monthToEdit: activeMonth,
        ),
      ),
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.activeMonth, required this.onEdit});

  final ActiveMonth activeMonth;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        MonthHeaderCard(activeMonth: activeMonth, onEdit: onEdit),
        const SizedBox(height: Dimens.spacingMd),
        Text(
          Strings.groupsSectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Dimens.spacingSm),
        for (final group in activeMonth.groups) GroupCard(group: group),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onStartMonth});

  final VoidCallback onStartMonth;

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
              Icons.wallet_outlined,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(Strings.homeEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.homeEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.spacingLg),
            FilledButton.icon(
              onPressed: onStartMonth,
              icon: const Icon(Icons.payments_outlined),
              label: const Text(Strings.startMonthCta),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: Dimens.iconXl,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: Dimens.spacingMd),
          Text(Strings.errorGeneric, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
