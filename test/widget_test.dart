import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/app.dart';
import 'package:grizzly_hills/core/strings.dart';
import 'package:grizzly_hills/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ThemeController> _buildThemeController() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return ThemeController.load();
}

void main() {
  testWidgets('muestra las cinco pestañas de navegación', (tester) async {
    final themeController = await _buildThemeController();

    await tester.pumpWidget(GrizzlyApp(themeController: themeController));

    expect(find.text(Strings.tabHome), findsWidgets);
    expect(find.text(Strings.tabLoans), findsOneWidget);
    expect(find.text(Strings.tabSavings), findsOneWidget);
    expect(find.text(Strings.tabBusiness), findsOneWidget);
    expect(find.text(Strings.tabMom), findsOneWidget);
  });

  testWidgets('cambia de pestaña al tocar Préstamos', (tester) async {
    final themeController = await _buildThemeController();
    await tester.pumpWidget(GrizzlyApp(themeController: themeController));

    await tester.tap(find.text(Strings.tabLoans));
    await tester.pumpAndSettle();

    expect(find.text(Strings.tabLoans), findsNWidgets(3));
    expect(find.text(Strings.comingSoon), findsOneWidget);
  });

  testWidgets('abre Ajustes y cambia el tema de color', (tester) async {
    final themeController = await _buildThemeController();
    await tester.pumpWidget(GrizzlyApp(themeController: themeController));

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsTitle), findsOneWidget);

    await tester.tap(find.text('Money'));
    await tester.pumpAndSettle();

    expect(themeController.scheme.name, 'money');
  });
}
