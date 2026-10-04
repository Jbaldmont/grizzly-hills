import 'package:flutter/material.dart';

import '../strings.dart';

Future<String?> showNameDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? initialName,
  Iterable<String> takenNames = const [],
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _NameDialog(
      title: title,
      confirmLabel: confirmLabel,
      initialName: initialName,
      takenNames: takenNames,
    ),
  );
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({
    required this.title,
    required this.confirmLabel,
    required this.takenNames,
    this.initialName,
  });

  final String title;
  final String confirmLabel;
  final Iterable<String> takenNames;
  final String? initialName;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late final Set<String> _takenKeys = {
    for (final name in widget.takenNames)
      if (name != widget.initialName) _normalize(name),
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: Strings.nameLabel,
            border: OutlineInputBorder(),
          ),
          validator: _validateName,
          onFieldSubmitted: (_) => _submit(),
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

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return Strings.nameRequiredError;
    }
    if (_takenKeys.contains(_normalize(name))) {
      return Strings.nameTakenError;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(_nameController.text.trim());
  }

  static String _normalize(String name) => name.trim().toLowerCase();
}
