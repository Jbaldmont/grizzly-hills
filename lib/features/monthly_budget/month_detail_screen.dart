import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../expenses/expense_list_screen.dart';
import '../expenses/expense_repository.dart';
import '../expenses/month_overview.dart';
import '../home/widgets/fixed_expenses_card.dart';
import '../home/widgets/group_card.dart';
import '../home/widgets/month_header_card.dart';
import '../home/widgets/unexpected_card.dart';
import 'month_repository.dart';

class MonthDetailScreen extends StatefulWidget {
  const MonthDetailScreen({
    super.key,
    required this.month,
    required this.monthRepository,
    required this.expenseRepository,
  });

  final Month month;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;

  @override
  State<MonthDetailScreen> createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  late final Future<MonthOverview> _overview = _loadOverview();

  Future<MonthOverview> _loadOverview() async {
    final activeMonth = await widget.monthRepository.loadActiveMonth(
      widget.month.id,
    );
    final expenses = await widget.expenseRepository.loadExpenses(
      widget.month.id,
    );
    return MonthOverview(activeMonth: activeMonth!, expenses: expenses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.monthLabel(widget.month.year, widget.month.month)),
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<MonthOverview>(
          future: _overview,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorState();
            }
            final overview = snapshot.data;
            if (overview == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent(overview);
          },
        ),
      ),
    );
  }

  Widget _buildContent(MonthOverview overview) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        MonthHeaderCard(overview: overview),
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
            onTap: () => _openExpenseList(group: group),
          ),
        const SizedBox(height: Dimens.spacingMd),
        FixedExpensesCard(
          overview: overview,
          expenseRepository: widget.expenseRepository,
          readOnly: true,
        ),
        const SizedBox(height: Dimens.spacingSm),
        UnexpectedCard(overview: overview, onTap: () => _openExpenseList()),
      ],
    );
  }

  void _openExpenseList({BudgetGroup? group}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExpenseListScreen(
          month: widget.month,
          monthRepository: widget.monthRepository,
          expenseRepository: widget.expenseRepository,
          group: group,
          readOnly: true,
        ),
      ),
    );
  }
}
