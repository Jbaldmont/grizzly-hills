import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/amount_row.dart';
import 'loan_form_sheet.dart';
import 'loan_interest.dart';
import 'loan_payment_sheet.dart';
import 'loan_repository.dart';

class LoanDetailScreen extends StatefulWidget {
  const LoanDetailScreen({
    super.key,
    required this.loanId,
    required this.loanRepository,
  });

  final int loanId;
  final LoanRepository loanRepository;

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  late final Stream<Loan?> _loan = widget.loanRepository.watchLoan(
    widget.loanId,
  );
  late final Stream<List<LoanPayment>> _payments = widget.loanRepository
      .watchPayments(widget.loanId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Loan?>(
      stream: _loan,
      builder: (context, loanSnapshot) {
        final loan = loanSnapshot.data;
        if (loan == null) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return StreamBuilder<List<LoanPayment>>(
          stream: _payments,
          builder: (context, paymentsSnapshot) {
            final payments = paymentsSnapshot.data ?? [];
            return _buildScaffold(loan, payments);
          },
        );
      },
    );
  }

  Widget _buildScaffold(Loan loan, List<LoanPayment> payments) {
    final isClosed = loan.closedAt != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(loan.debtorName),
        actions: [
          if (!isClosed)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: Strings.editLoanTitle,
              onPressed: () => showLoanFormSheet(
                context,
                loanRepository: widget.loanRepository,
                loanToEdit: loan,
                hasPayments: payments.isNotEmpty,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: Strings.delete,
            onPressed: () => _confirmDelete(loan),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        children: [
          _LoanSummaryCard(loan: loan),
          const SizedBox(height: Dimens.spacingMd),
          if (!isClosed)
            FilledButton.icon(
              onPressed: () => showLoanPaymentSheet(
                context,
                loan: loan,
                loanRepository: widget.loanRepository,
              ),
              icon: const Icon(Icons.payments_outlined),
              label: const Text(Strings.registerPaymentCta),
            ),
          const SizedBox(height: Dimens.spacingMd),
          Text(
            Strings.paymentsSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Dimens.spacingSm),
          if (payments.isEmpty)
            Text(
              Strings.noPaymentsYet,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          for (final payment in payments)
            Card(
              child: ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: Text(formatBs(payment.amountCents)),
                trailing: Text(formatShortDate(payment.date)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Loan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.deleteLoanTitle),
        content: const Text(Strings.deleteLoanBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.delete),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && mounted) {
      await widget.loanRepository.deleteLoan(loan.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _LoanSummaryCard extends StatelessWidget {
  const _LoanSummaryCard({required this.loan});

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final closedAt = loan.closedAt;
    final overdue = closedAt == null && isOverdue(loan, today);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateRow(
              label: Strings.lentOnLabel,
              date: loan.loanDate,
            ),
            _DateRow(
              label: Strings.dueDateLabel,
              date: loan.dueDate,
              highlight: overdue,
              suffix: overdue ? ' · ${Strings.overdueLabel}' : '',
            ),
            if (closedAt != null)
              _DateRow(label: Strings.closedOnLabel, date: closedAt),
            const Divider(),
            AmountRow(
              label: Strings.loanBaseRowLabel,
              amountCents: loan.principalCents,
            ),
            AmountRow(
              label: Strings.loanInterestRowLabel,
              amountCents: accruedInterestCents(loan, today),
            ),
            AmountRow(
              label: Strings.loanTotalRowLabel,
              amountCents: totalOwedCents(loan, today),
              emphasized: true,
            ),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.weeklyInterestNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.date,
    this.highlight = false,
    this.suffix = '',
  });

  final String label;
  final DateTime date;
  final bool highlight;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = highlight
        ? theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('${formatShortDate(date)}$suffix', style: style),
        ],
      ),
    );
  }
}
