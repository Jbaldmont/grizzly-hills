import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/app.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/core/strings.dart';
import 'package:grizzly_hills/core/theme/theme_controller.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GrizzlyApp> _buildApp(AppDatabase db) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final themeController = await ThemeController.load();
  return GrizzlyApp(
    themeController: themeController,
    monthRepository: MonthRepository(db),
  );
}

Future<void> _disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('muestra las cinco pestañas de navegación', (tester) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    expect(find.text(Strings.tabHome), findsWidgets);
    expect(find.text(Strings.tabLoans), findsOneWidget);
    expect(find.text(Strings.tabSavings), findsOneWidget);
    expect(find.text(Strings.tabBusiness), findsOneWidget);
    expect(find.text(Strings.tabMom), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('sin mes abierto, Inicio invita a registrar el sueldo', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    expect(find.text(Strings.homeEmptyTitle), findsOneWidget);
    expect(find.text(Strings.startMonthCta), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('flujo completo: abrir el mes crea los grupos de la plantilla', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Strings.startMonthCta));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '3000');
    await tester.scrollUntilVisible(
      find.text(Strings.startMonthConfirm),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(Strings.startMonthConfirm));
    await tester.pumpAndSettle();

    expect(find.text('Agua, Luz y Teléfonos'), findsOneWidget);
    expect(find.text(Strings.generalBudgetRowLabel), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Gasolina'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Gasolina'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('sueldo menor a lo asignado pide confirmación al abrir el mes', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Strings.startMonthCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '100');
    await tester.scrollUntilVisible(
      find.text(Strings.startMonthConfirm),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(Strings.startMonthConfirm));
    await tester.pumpAndSettle();

    expect(find.text(Strings.overAssignedDialogTitle), findsOneWidget);

    await tester.tap(find.text(Strings.cancel));
    await tester.pumpAndSettle();
    expect(find.text(Strings.startMonthConfirm), findsOneWidget);

    await tester.tap(find.text(Strings.startMonthConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.continueAnyway));
    await tester.pumpAndSettle();

    expect(find.text(Strings.homeEmptyTitle), findsNothing);
    expect(find.text(Strings.generalBudgetRowLabel), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('permite editar el sueldo del mes abierto', (tester) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Strings.startMonthCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '3000');
    await tester.scrollUntilVisible(
      find.text(Strings.startMonthConfirm),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(Strings.startMonthConfirm));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.text(Strings.editMonthTitle), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '5000');
    await tester.scrollUntilVisible(
      find.text(Strings.saveChanges),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(Strings.saveChanges));
    await tester.pumpAndSettle();

    expect(find.text('Bs 5.000'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('abre Ajustes y cambia el tema de color', (tester) async {
    await tester.pumpWidget(await _buildApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsTitle), findsOneWidget);

    await tester.tap(find.text('Money'));
    await tester.pumpAndSettle();

    await _disposeApp(tester);
  });
}
