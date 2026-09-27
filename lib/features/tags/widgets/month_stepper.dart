import 'package:flutter/material.dart';

import '../../../core/strings.dart';

class MonthStepper extends StatelessWidget {
  const MonthStepper({
    super.key,
    required this.label,
    this.onPrevious,
    this.onNext,
  });

  final String label;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: Strings.previousMonthTooltip,
          onPressed: onPrevious,
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: Strings.nextMonthTooltip,
          onPressed: onNext,
        ),
      ],
    );
  }
}
