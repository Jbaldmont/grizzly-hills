import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import 'loan_detail_screen.dart';
import 'loan_repository.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key, required this.loanRepository});

  final LoanRepository loanRepository;

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  late final Stream<List<Loan>> _closedLoans = widget.loanRepository
      .watchClosedLoans();
  late final Stream<Map<int, int>> _totalPaid = widget.loanRepository
      .watchTotalPaidByLoan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.loanHistoryTitle)),
      body: StreamBuilder<List<Loan>>(
        stream: _closedLoans,
        builder: (context, loansSnapshot) {
          if (loansSnapshot.hasError) {
            return const ErrorState();
          }
          if (loansSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final loans = loansSnapshot.data ?? [];
          if (loans.isEmpty) {
            return const _EmptyHistory();
          }
          return StreamBuilder<Map<int, int>>(
            stream: _totalPaid,
            builder: (context, totalsSnapshot) {
              final totals = totalsSnapshot.data ?? {};
              return ListView(
                padding: const EdgeInsets.all(Dimens.spacingMd),
                children: [
                  for (final loan in loans)
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () => _openDetail(loan),
                        leading: const Icon(Icons.task_alt),
                        title: Text(loan.debtorName),
                        subtitle: Text(
                          '${Strings.lentOnLabel} '
                          '${formatShortDate(loan.loanDate)} · '
                          '${Strings.closedOnLabel} '
                          '${formatShortDate(loan.closedAt!)}',
                        ),
                        trailing: Text(
                          formatBs(totals[loan.id] ?? 0),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _openDetail(Loan loan) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LoanDetailScreen(
          loanId: loan.id,
          loanRepository: widget.loanRepository,
        ),
      ),
    );
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
              Strings.loanHistoryEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
