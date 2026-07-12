import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/widgets/coming_soon_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      icon: Icons.wallet_outlined,
      featureName: Strings.tabHome,
    );
  }
}
