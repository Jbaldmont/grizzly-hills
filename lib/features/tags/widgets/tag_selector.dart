import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/dimens.dart';
import '../../../core/strings.dart';
import '../../../core/widgets/name_dialog.dart';
import '../tag_repository.dart';

class TagSelector extends StatefulWidget {
  const TagSelector({
    super.key,
    required this.tagRepository,
    required this.selectedTagId,
    required this.onChanged,
  });

  final TagRepository tagRepository;
  final int? selectedTagId;
  final ValueChanged<int?> onChanged;

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late final Stream<List<ExpenseTag>> _tags = widget.tagRepository.watchTags();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpenseTag>>(
      stream: _tags,
      builder: (context, snapshot) {
        final tags = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.tagFieldLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: Dimens.spacingSm),
            Wrap(
              spacing: Dimens.spacingSm,
              runSpacing: Dimens.spacingXs,
              children: [
                for (final tag in tags)
                  ChoiceChip(
                    label: Text(tag.name),
                    selected: tag.id == widget.selectedTagId,
                    onSelected: (selected) =>
                        widget.onChanged(selected ? tag.id : null),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add),
                  label: const Text(Strings.newTagChip),
                  onPressed: () => _createTag(tags),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _createTag(List<ExpenseTag> existingTags) async {
    final name = await showNameDialog(
      context,
      title: Strings.newTagTitle,
      confirmLabel: Strings.add,
      takenNames: [for (final tag in existingTags) tag.name],
    );
    if (name == null) {
      return;
    }
    try {
      final tagId = await widget.tagRepository.addTag(name);
      widget.onChanged(tagId);
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }
}
