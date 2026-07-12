import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/widgets/coming_soon_screen.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      icon: Icons.storefront_outlined,
      featureName: Strings.tabBusiness,
    );
  }
}
