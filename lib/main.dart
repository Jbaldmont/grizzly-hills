import 'package:flutter/material.dart';
import 'app.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.load();
  runApp(GrizzlyApp(themeController: themeController));
}
