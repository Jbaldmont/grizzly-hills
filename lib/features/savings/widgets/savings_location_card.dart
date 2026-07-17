import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/money.dart';
import '../../../core/strings.dart';

enum SavingsLocationAction { rename, delete }

class SavingsLocationCard extends StatelessWidget {
  const SavingsLocationCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.onAction,
  });

  final SavingsLocation location;
  final VoidCallback onTap;
  final ValueChanged<SavingsLocationAction> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.account_balance_wallet_outlined),
        title: Text(location.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatBs(location.balanceCents),
              style: theme.textTheme.titleMedium,
            ),
            PopupMenuButton<SavingsLocationAction>(
              onSelected: onAction,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: SavingsLocationAction.rename,
                  child: Text(Strings.rename),
                ),
                PopupMenuItem(
                  value: SavingsLocationAction.delete,
                  child: Text(Strings.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
