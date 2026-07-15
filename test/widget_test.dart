import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/core/strings.dart';

import 'app_test_utils.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('muestra las cinco pestañas de navegación', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    expect(find.text(Strings.tabHome), findsWidgets);
    expect(find.text(Strings.tabLoans), findsOneWidget);
    expect(find.text(Strings.tabSavings), findsOneWidget);
    expect(find.text(Strings.tabBusiness), findsOneWidget);
    expect(find.text(Strings.tabMom), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('sin mes abierto, Inicio invita a registrar el sueldo', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    expect(find.text(Strings.homeEmptyTitle), findsOneWidget);
    expect(find.text(Strings.startMonthCta), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('flujo completo: abrir el mes crea los grupos de la plantilla', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    await openTestMonth(tester);

    expect(find.text('Agua, Luz y Teléfonos'), findsOneWidget);
    expect(find.text(Strings.availableGeneralRowLabel), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Gasolina'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Gasolina'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('sueldo menor a lo asignado pide confirmación al abrir el mes', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
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
    expect(find.text(Strings.availableGeneralRowLabel), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('permite editar el sueldo del mes abierto', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    await openTestMonth(tester);

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

    await disposeTestApp(tester);
  });

  testWidgets('abre Ajustes y cambia el tema de color', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsTitle), findsOneWidget);

    await tester.tap(find.text('Money'));
    await tester.pumpAndSettle();

    await disposeTestApp(tester);
  });
}
