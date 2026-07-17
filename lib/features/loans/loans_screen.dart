import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/total_amount_card.dart';
import 'loan_detail_screen.dart';
import 'loan_form_sheet.dart';
import 'loan_history_screen.dart';
import 'loan_interest.dart';
import 'loan_repository.dart';
import 'widgets/loan_card.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key, required this.loanRepository});

  final LoanRepository loanRepository;

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  late final Stream<List<Loan>> _activeLoans = widget.loanRepository
      .watchActiveLoans();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Loan>>(
      stream: _activeLoans,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final loans = snapshot.data ?? [];
        if (loans.isEmpty) {
          return _EmptyState(
            onNewLoan: _openNewLoan,
            onHistory: _openHistory,
          );
        }
        return _buildContent(loans);
      },
    );
  }

  Widget _buildContent(List<Loan> loans) {
    final today = DateTime.now();
    final totalCents = loans.fold<int>(
      0,
      (sum, loan) => sum + totalOwedCents(loan, today),
    );
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [
        TotalAmountCard(
          label: Strings.loansTotalLabel,
          totalCents: totalCents,
        ),
        const SizedBox(height: Dimens.spacingSm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openHistory,
                icon: const Icon(Icons.history),
                label: const Text(Strings.loanHistoryCta),
              ),
            ),
            const SizedBox(width: Dimens.spacingSm),
            Expanded(
              child: FilledButton.icon(
                onPressed: _openNewLoan,
                icon: const Icon(Icons.add),
                label: const Text(Strings.newLoanCta),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingMd),
        for (final loan in loans)
          LoanCard(loan: loan, onTap: () => _openDetail(loan)),
      ],
    );
  }

  void _openNewLoan() {
    showLoanFormSheet(context, loanRepository: widget.loanRepository);
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            LoanHistoryScreen(loanRepository: widget.loanRepository),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onNewLoan, required this.onHistory});

  final VoidCallback onNewLoan;
  final VoidCallback onHistory;

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
              Icons.handshake_outlined,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(Strings.loansEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.loansEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.spacingLg),
            FilledButton.icon(
              onPressed: onNewLoan,
              icon: const Icon(Icons.add),
              label: const Text(Strings.newLoanCta),
            ),
            const SizedBox(height: Dimens.spacingSm),
            TextButton.icon(
              onPressed: onHistory,
              icon: const Icon(Icons.history),
              label: const Text(Strings.loanHistoryCta),
            ),
          ],
        ),
      ),
    );
  }
}
