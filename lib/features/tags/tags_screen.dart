import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/name_dialog.dart';
import 'tag_repository.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key, required this.tagRepository});

  final TagRepository tagRepository;

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  late final Stream<List<ExpenseTag>> _tags = widget.tagRepository
      .watchTags();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpenseTag>>(
      stream: _tags,
      builder: (context, snapshot) {
        final tags = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(title: const Text(Strings.tagsTitle)),
          floatingActionButton: FloatingActionButton(
            tooltip: Strings.newTagTitle,
            onPressed: () => _addTag(tags),
            child: const Icon(Icons.add),
          ),
          body: SafeArea(top: false, child: _buildBody(snapshot, tags)),
        );
      },
    );
  }

  Widget _buildBody(
    AsyncSnapshot<List<ExpenseTag>> snapshot,
    List<ExpenseTag> tags,
  ) {
    if (snapshot.hasError) {
      return const ErrorState();
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tags.isEmpty) {
      return const _EmptyTags();
    }
    return ListView(
      padding: const EdgeInsets.all(Dimens.spacingMd),
      children: [for (final tag in tags) _buildTile(tag, tags)],
    );
  }

  Widget _buildTile(ExpenseTag tag, List<ExpenseTag> tags) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.sell_outlined),
        title: Text(tag.name),
        onTap: () => _renameTag(tag, tags),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: Strings.delete,
          onPressed: () => _deleteTag(tag),
        ),
      ),
    );
  }

  Future<void> _addTag(List<ExpenseTag> tags) async {
    final name = await showNameDialog(
      context,
      title: Strings.newTagTitle,
      confirmLabel: Strings.add,
      takenNames: [for (final tag in tags) tag.name],
    );
    if (name != null) {
      await _run(() => widget.tagRepository.addTag(name));
    }
  }

  Future<void> _renameTag(ExpenseTag tag, List<ExpenseTag> tags) async {
    final name = await showNameDialog(
      context,
      title: Strings.renameTagTitle,
      confirmLabel: Strings.save,
      initialName: tag.name,
      takenNames: [for (final otherTag in tags) otherTag.name],
    );
    if (name != null) {
      await _run(() => widget.tagRepository.renameTag(id: tag.id, name: name));
    }
  }

  Future<void> _deleteTag(ExpenseTag tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.deleteTagTitle),
        content: const Text(Strings.deleteTagBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await _run(() => widget.tagRepository.deleteTag(tag.id));
    }
  }

  Future<void> _run(Future<Object?> Function() action) async {
    try {
      await action();
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }
}

class _EmptyTags extends StatelessWidget {
  const _EmptyTags();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sell_outlined,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(
              Strings.tagsEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.tagsEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
