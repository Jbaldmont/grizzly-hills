import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/date_field.dart';
import '../../core/widgets/sheet_padding.dart';
import 'loan_interest.dart';
import 'loan_repository.dart';

const int _defaultLoanTermDays = 14;

void showLoanFormSheet(
  BuildContext context, {
  required LoanRepository loanRepository,
  Loan? loanToEdit,
  bool hasPayments = false,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => LoanFormSheet(
      loanRepository: loanRepository,
      loanToEdit: loanToEdit,
      hasPayments: hasPayments,
    ),
  );
}

class LoanFormSheet extends StatefulWidget {
  const LoanFormSheet({
    super.key,
    required this.loanRepository,
    this.loanToEdit,
    this.hasPayments = false,
  });

  final LoanRepository loanRepository;
  final Loan? loanToEdit;
  final bool hasPayments;

  @override
  State<LoanFormSheet> createState() => _LoanFormSheetState();
}

class _LoanFormSheetState extends State<LoanFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _debtorController;
  late final TextEditingController _amountController;
  late final TextEditingController _rateController;
  late DateTime _loanDate;
  late DateTime _dueDate;
  bool _saving = false;

  bool get _isEditing => widget.loanToEdit != null;

  bool get _principalLocked => widget.hasPayments;

  @override
  void initState() {
    super.initState();
    final loan = widget.loanToEdit;
    _debtorController = TextEditingController(text: loan?.debtorName ?? '');
    _amountController = TextEditingController(
      text: loan == null ? '' : centsToEditableText(loan.principalCents),
    );
    _rateController = TextEditingController(
      text: formatPercent(
        loan?.weeklyRatePercent ?? defaultWeeklyRatePercent,
      ).replaceAll('%', ''),
    );
    _loanDate = dateOnly(loan?.loanDate ?? DateTime.now());
    _dueDate = dateOnly(
      loan?.dueDate ??
          DateTime.now().add(const Duration(days: _defaultLoanTermDays)),
    );
  }

  @override
  void dispose() {
    _debtorController.dispose();
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SheetPadding(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? Strings.editLoanTitle : Strings.newLoanCta,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _debtorController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: Strings.debtorNameLabel,
                border: OutlineInputBorder(),
              ),
              validator: _validateDebtor,
            ),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _amountController,
              enabled: !_principalLocked,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: Strings.loanAmountLabel,
                prefixText: '${Strings.currency} ',
                border: OutlineInputBorder(),
              ),
              validator: _validateAmount,
            ),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: Strings.interestRateLabel,
                border: OutlineInputBorder(),
              ),
              validator: _validateRate,
            ),
            const SizedBox(height: Dimens.spacingSm),
            if (!_principalLocked)
              DateField(
                label: Strings.loanDateLabel,
                date: _loanDate,
                lastDate: DateTime.now(),
                onChanged: (value) => setState(() => _loanDate = value),
              ),
            DateField(
              label: Strings.dueDateLabel,
              date: _dueDate,
              onChanged: (value) => setState(() => _dueDate = value),
            ),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.startedWeekNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
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

  String? _validateDebtor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.debtorNameRequiredError;
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (_principalLocked) {
      return null;
    }
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    return null;
  }

  String? _validateRate(String? value) {
    final percent = parsePercent(value ?? '');
    if (percent == null || percent <= 0 || percent > 100) {
      return Strings.invalidInterestRateError;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _persist();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }

  Future<void> _persist() {
    final debtorName = _debtorController.text.trim();
    final weeklyRatePercent = parsePercent(_rateController.text)!;
    final loan = widget.loanToEdit;
    if (loan == null) {
      return widget.loanRepository.addLoan(
        debtorName: debtorName,
        principalCents: parseBsToCents(_amountController.text)!,
        loanDate: _loanDate,
        dueDate: _dueDate,
        weeklyRatePercent: weeklyRatePercent,
      );
    }
    return widget.loanRepository.updateLoan(
      id: loan.id,
      debtorName: debtorName,
      dueDate: _dueDate,
      principalCents: _principalLocked
          ? null
          : parseBsToCents(_amountController.text)!,
      loanDate: _principalLocked ? null : _loanDate,
      weeklyRatePercent: weeklyRatePercent,
    );
  }
}
