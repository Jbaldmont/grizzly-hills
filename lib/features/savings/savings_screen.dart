import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/widgets/coming_soon_screen.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      icon: Icons.savings_outlined,
      featureName: Strings.tabSavings,
    );
  }
}
