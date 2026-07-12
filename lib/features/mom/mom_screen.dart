import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/widgets/coming_soon_screen.dart';

class MomScreen extends StatelessWidget {
  const MomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      icon: Icons.favorite_outline,
      featureName: Strings.tabMom,
    );
  }
}
