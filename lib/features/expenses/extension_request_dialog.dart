import 'package:flutter/material.dart';

import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';

class ExtensionAmountDialog extends StatefulWidget {
  const ExtensionAmountDialog({
    super.key,
    required this.title,
    required this.limitLabel,
    required this.limitCents,
    required this.confirmLabel,
    required this.exceedsLimitError,
  });

  final String title;
  final String limitLabel;
  final int limitCents;
  final String confirmLabel;
  final String exceedsLimitError;

  @override
  State<ExtensionAmountDialog> createState() => _ExtensionAmountDialogState();
}

class _ExtensionAmountDialogState extends State<ExtensionAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${widget.limitLabel}: ${formatBs(widget.limitCents)}'),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    if (cents > widget.limitCents) {
      return widget.exceedsLimitError;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(parseBsToCents(_amountController.text));
  }
}
