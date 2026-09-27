import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import '../../../core/strings.dart';
import '../tag_statistics.dart';

class ScopeChips extends StatelessWidget {
  const ScopeChips({
    super.key,
    required this.groupNames,
    required this.selected,
    required this.onSelected,
  });

  final List<String> groupNames;
  final SpendingScope selected;
  final ValueChanged<SpendingScope> onSelected;

  @override
  Widget build(BuildContext context) {
    final scopes = [
      (scope: const SpendingScope.all(), label: Strings.allScopeLabel),
      for (final groupName in groupNames)
        (scope: SpendingScope.group(groupName), label: groupName),
      (
        scope: const SpendingScope.unexpected(),
        label: Strings.unexpectedSectionTitle,
      ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final option in scopes)
            Padding(
              padding: const EdgeInsets.only(right: Dimens.spacingSm),
              child: ChoiceChip(
                label: Text(option.label),
                selected: option.scope == selected,
                onSelected: (_) => onSelected(option.scope),
              ),
            ),
        ],
      ),
    );
  }
}
