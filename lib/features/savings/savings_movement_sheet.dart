import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/sheet_padding.dart';
import 'savings_repository.dart';

enum _MovementKind { deposit, withdraw }

void showSavingsMovementSheet(
  BuildContext context, {
  required SavingsLocation location,
  required SavingsRepository savingsRepository,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SavingsMovementSheet(
      location: location,
      savingsRepository: savingsRepository,
    ),
  );
}

class SavingsMovementSheet extends StatefulWidget {
  const SavingsMovementSheet({
    super.key,
    required this.location,
    required this.savingsRepository,
  });

  final SavingsLocation location;
  final SavingsRepository savingsRepository;

  @override
  State<SavingsMovementSheet> createState() => _SavingsMovementSheetState();
}

class _SavingsMovementSheetState extends State<SavingsMovementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  _MovementKind _kind = _MovementKind.deposit;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
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
            Text(widget.location.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              '${Strings.savingsTotalLabel}: '
              '${formatBs(widget.location.balanceCents)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.spacingMd),
            SegmentedButton<_MovementKind>(
              segments: const [
                ButtonSegment(
                  value: _MovementKind.deposit,
                  label: Text(Strings.deposit),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: _MovementKind.withdraw,
                  label: Text(Strings.withdraw),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (selection) =>
                  setState(() => _kind = selection.first),
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

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    if (_kind == _MovementKind.withdraw &&
        cents > widget.location.balanceCents) {
      return Strings.withdrawTooMuchError;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final cents = parseBsToCents(_amountController.text)!;
    final deltaCents = _kind == _MovementKind.deposit ? cents : -cents;
    setState(() => _saving = true);
    try {
      await widget.savingsRepository.adjustBalance(
        id: widget.location.id,
        deltaCents: deltaCents,
      );
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
}
