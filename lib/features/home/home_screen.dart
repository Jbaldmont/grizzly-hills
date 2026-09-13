import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../expenses/expense_list_screen.dart';
import '../expenses/expense_repository.dart';
import '../expenses/month_overview.dart';
import '../monthly_budget/month_repository.dart';
import '../monthly_budget/start_month_screen.dart';
import 'widgets/fixed_expenses_card.dart';
import 'widgets/group_card.dart';
import 'widgets/month_header_card.dart';
import 'widgets/unexpected_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.monthRepository,
    required this.expenseRepository,
  });

  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<ActiveMonth?> _activeMonth = widget.monthRepository
      .watchActiveMonth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ActiveMonth?>(
      stream: _activeMonth,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final activeMonth = snapshot.data;
        if (activeMonth == null) {
          return _EmptyState(onStartMonth: _openStartMonth);
        }
        return _MonthContent(
          key: ValueKey(activeMonth.month.id),
          activeMonth: activeMonth,
          monthRepository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
          onEdit: () => _openEditMonth(activeMonth),
        );
      },
    );
  }

  void _openStartMonth() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StartMonthScreen(
          repository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
        ),
      ),
    );
  }

  void _openEditMonth(ActiveMonth activeMonth) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StartMonthScreen(
          repository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
          monthToEdit: activeMonth,
        ),
      ),
    );
  }
}

class _MonthContent extends StatefulWidget {
  const _MonthContent({
    super.key,
    required this.activeMonth,
    required this.monthRepository,
    required this.expenseRepository,
    required this.onEdit,
  });

  final ActiveMonth activeMonth;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final VoidCallback onEdit;

  @override
  State<_MonthContent> createState() => _MonthContentState();
}

class _MonthContentState extends State<_MonthContent> {
  late final Stream<List<Expense>> _expenses = widget.expenseRepository
      .watchExpenses(widget.activeMonth.month.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: _expenses,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final overview = MonthOverview(
          activeMonth: widget.activeMonth,
          expenses: snapshot.data ?? [],
        );
        return _MonthSummary(
          overview: overview,
          monthRepository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
          onEdit: widget.onEdit,
        );
      },
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({
    required this.overview,
    required this.monthRepository,
    required this.expenseRepository,
    required this.onEdit,
  });

  final MonthOverview overview;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        MonthHeaderCard(overview: overview, onEdit: onEdit),
        const SizedBox(height: Dimens.spacingMd),
        Text(
          Strings.groupsSectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Dimens.spacingSm),
        for (final group in overview.activeMonth.groups)
          GroupCard(
            group: group,
            spentCents: overview.spentInGroupCents(group.id),
            extensionCents: overview.extensionCentsForGroup(group.id),
            onTap: () => _openExpenseList(context, group: group),
          ),
        const SizedBox(height: Dimens.spacingMd),
        FixedExpensesCard(
          overview: overview,
          expenseRepository: expenseRepository,
        ),
        const SizedBox(height: Dimens.spacingSm),
        UnexpectedCard(
          overview: overview,
          onTap: () => _openExpenseList(context),
        ),
      ],
    );
  }

  void _openExpenseList(BuildContext context, {BudgetGroup? group}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExpenseListScreen(
          month: overview.activeMonth.month,
          monthRepository: monthRepository,
          expenseRepository: expenseRepository,
          group: group,
        ),
      ),
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
