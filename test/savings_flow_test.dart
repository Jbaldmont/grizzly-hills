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

  Future<void> openSavingsTab(WidgetTester tester) async {
    await tester.tap(find.text(Strings.tabSavings));
    await tester.pumpAndSettle();
  }

  Future<void> addLocation(WidgetTester tester, String name) async {
    await tester.tap(find.text(Strings.addLocationCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), name);
    await tester.tap(find.text(Strings.add));
    await tester.pumpAndSettle();
  }

  testWidgets('agregar una ubicación desde el estado vacío', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openSavingsTab(tester);

    expect(find.text(Strings.savingsEmptyTitle), findsOneWidget);

    await addLocation(tester, 'Caja roja');

    expect(find.text('Caja roja'), findsOneWidget);
    expect(find.text(Strings.savingsTotalLabel), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('depositar en una ubicación actualiza el total', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openSavingsTab(tester);
    await addLocation(tester, 'Banco Unión');

    await tester.tap(find.text('Banco Unión'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '150');
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    expect(find.text('Bs 150'), findsNWidgets(2));

    await disposeTestApp(tester);
  });

  testWidgets('retirar más de lo disponible muestra error', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openSavingsTab(tester);
    await addLocation(tester, 'Caja roja');

    await tester.tap(find.text('Caja roja'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.withdraw));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '50');
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    expect(find.text(Strings.withdrawTooMuchError), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('transferir de un grupo al ahorro', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);
    await openSavingsTab(tester);
    await addLocation(tester, 'Caja roja');

    await tester.tap(find.text(Strings.transferCta));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Gasolina').first);
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Caja roja'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '50');
    await tester.tap(
      find.widgetWithText(FilledButton, Strings.transferCta).last,
    );
    await tester.pumpAndSettle();

    expect(find.text(Strings.transferDoneMessage), findsOneWidget);
    expect(find.text('Bs 50'), findsNWidgets(2));

    await tester.tap(find.text(Strings.tabHome));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Gasolina'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Gasolina'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('${Strings.spentLabel}: Bs 50'), findsOneWidget);

    await tester.drag(find.byIcon(Icons.lock_outline), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await disposeTestApp(tester);
  });

  testWidgets('transferir sin mes abierto avisa primero abrir el mes', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openSavingsTab(tester);
    await addLocation(tester, 'Caja roja');

    await tester.tap(find.text(Strings.transferCta));
    await tester.pumpAndSettle();

    expect(find.text(Strings.openMonthFirst), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await disposeTestApp(tester);
  });
}
