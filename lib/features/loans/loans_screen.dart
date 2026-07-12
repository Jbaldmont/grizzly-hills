import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/widgets/coming_soon_screen.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      icon: Icons.handshake_outlined,
      featureName: Strings.tabLoans,
    );
  }
}
