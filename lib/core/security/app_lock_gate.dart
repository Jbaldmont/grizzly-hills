import 'package:flutter/material.dart';

import 'lock_controller.dart';
import 'lock_screen.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({
    super.key,
    required this.lockController,
    required this.child,
  });

  final LockController lockController;
  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.lockController.lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.lockController,
      builder: (context, _) => widget.lockController.isUnlocked
          ? widget.child
          : LockScreen(lockController: widget.lockController),
    );
  }
}
