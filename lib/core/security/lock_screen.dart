import 'package:flutter/material.dart';

import '../dimens.dart';
import '../strings.dart';
import 'lock_controller.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.lockController});

  final LockController lockController;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_authenticating) {
      return;
    }
    setState(() => _authenticating = true);
    await widget.lockController.authenticate(Strings.lockScreenReason);
    if (mounted) {
      setState(() => _authenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.spacingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fingerprint,
                  size: Dimens.iconXl,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: Dimens.spacingMd),
                Text(
                  Strings.lockScreenTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimens.spacingSm),
                Text(
                  Strings.lockScreenBody,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimens.spacingLg),
                FilledButton.icon(
                  onPressed: _authenticating ? null : _authenticate,
                  icon: const Icon(Icons.lock_open),
                  label: const Text(Strings.unlockCta),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
