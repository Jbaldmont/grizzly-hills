import 'package:flutter/material.dart';
import 'core/strings.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'shell/app_shell.dart';

class GrizzlyApp extends StatelessWidget {
  const GrizzlyApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: Strings.appTitle,
        theme: buildLightTheme(themeController.scheme),
        darkTheme: buildDarkTheme(themeController.scheme),
        themeMode: themeController.mode,
        home: AppShell(themeController: themeController),
      ),
    );
  }
}
