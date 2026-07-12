import 'package:flutter/material.dart';

import '../dimens.dart';
import '../strings.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.icon,
    required this.featureName,
  });

  final IconData icon;
  final String featureName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: Dimens.iconXl, color: theme.colorScheme.primary),
          const SizedBox(height: Dimens.spacingMd),
          Text(featureName, style: theme.textTheme.titleLarge),
          const SizedBox(height: Dimens.spacingXs),
          Text(
            Strings.comingSoon,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
