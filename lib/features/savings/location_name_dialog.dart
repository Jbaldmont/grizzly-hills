import 'package:flutter/material.dart';

import '../../core/strings.dart';

Future<String?> showLocationNameDialog(
  BuildContext context, {
  String? initialName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _LocationNameDialog(initialName: initialName),
  );
}

class _LocationNameDialog extends StatefulWidget {
  const _LocationNameDialog({this.initialName});

  final String? initialName;

  @override
  State<_LocationNameDialog> createState() => _LocationNameDialogState();
}

class _LocationNameDialogState extends State<_LocationNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );

  bool get _isRenaming => widget.initialName != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isRenaming ? Strings.renameLocationTitle : Strings.newLocationTitle,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: Strings.locationNameLabel,
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
        FilledButton(
          onPressed: _submit,
          child: Text(_isRenaming ? Strings.save : Strings.add),
        ),
      ],
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.locationNameRequiredError;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(_nameController.text.trim());
  }
}
