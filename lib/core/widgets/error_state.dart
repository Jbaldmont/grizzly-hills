import 'package:flutter/material.dart';

import '../dimens.dart';
import '../strings.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: Dimens.iconXl,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: Dimens.spacingMd),
          Text(Strings.errorGeneric, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
