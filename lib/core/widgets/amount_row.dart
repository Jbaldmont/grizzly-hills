import 'package:flutter/material.dart';

import '../dimens.dart';
import '../money.dart';

class AmountRow extends StatelessWidget {
  const AmountRow({
    super.key,
    required this.label,
    required this.amountCents,
    this.emphasized = false,
  });

  final String label;
  final int amountCents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(
            color: amountCents < 0
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatBs(amountCents), style: style),
        ],
      ),
    );
  }
}
