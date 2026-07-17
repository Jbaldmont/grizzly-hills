import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/date_field.dart';
import 'loan_interest.dart';
import 'loan_repository.dart';

void showLoanPaymentSheet(
  BuildContext context, {
  required Loan loan,
  required LoanRepository loanRepository,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => LoanPaymentSheet(loan: loan, loanRepository: loanRepository),
  );
}

class LoanPaymentSheet extends StatefulWidget {
  const LoanPaymentSheet({
    super.key,
    required this.loan,
    required this.loanRepository,
  });

  final Loan loan;
  final LoanRepository loanRepository;

  @override
  State<LoanPaymentSheet> createState() => _LoanPaymentSheetState();
}

class _LoanPaymentSheetState extends State<LoanPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late DateTime _date = dateOnly(DateTime.now());
  bool _saving = false;

  int get _owedAtDateCents => totalOwedCents(widget.loan, _date);

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountCents = parseBsToCents(_amountController.text);
    final closesLoan = amountCents != null && amountCents >= _owedAtDateCents;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.spacingMd,
        right: Dimens.spacingMd,
        top: Dimens.spacingMd,
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.spacingMd,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.registerPaymentCta, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              '${Strings.loanTotalRowLabel}: ${formatBs(_owedAtDateCents)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: Strings.amountLabel,
                prefixText: '${Strings.currency} ',
                border: OutlineInputBorder(),
              ),
              validator: _validateAmount,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Dimens.spacingSm),
            DateField(
              label: Strings.dateLabel,
              date: _date,
              firstDate: widget.loan.interestStartDate,
              lastDate: DateTime.now(),
              onChanged: (value) => setState(() => _date = value),
            ),
            if (closesLoan) ...[
              const SizedBox(height: Dimens.spacingXs),
              Text(
                Strings.paymentClosesLoanNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: Dimens.spacingMd),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text(Strings.save),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final closed = await widget.loanRepository.registerPayment(
        loanId: widget.loan.id,
        amountCents: parseBsToCents(_amountController.text)!,
        date: _date,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            closed ? Strings.loanClosedMessage : Strings.paymentRegisteredMessage,
          ),
        ),
      );
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }
}
