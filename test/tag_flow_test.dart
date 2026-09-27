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

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> addExpense(
    WidgetTester tester, {
    required String amount,
    required String destination,
    String? tag,
  }) async {
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, amount);
    await tapVisible(tester, find.widgetWithText(ChoiceChip, destination));
    if (tag != null) {
      await tapVisible(tester, find.widgetWithText(ChoiceChip, tag));
    }
    await tapVisible(tester, find.text(Strings.save));
  }

  testWidgets('el gasto guarda su etiqueta y se ve en el detalle del grupo', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await addExpense(tester, amount: '50', destination: 'Gasolina', tag: 'Comida');

    await tester.scrollUntilVisible(
      find.text('Gasolina'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Gasolina'));
    await tester.pumpAndSettle();

    expect(find.textContaining('· Comida'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('crear una etiqueta desde el gasto la deja elegida', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.widgetWithText(ActionChip, Strings.newTagChip));
    await tester.enterText(find.byType(TextFormField).last, 'comida');
    await tester.tap(find.text(Strings.add));
    await tester.pumpAndSettle();
    expect(find.text(Strings.nameTakenError), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, 'Salidas');
    await tester.tap(find.text(Strings.add));
    await tester.pumpAndSettle();

    final newChip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Salidas'),
    );
    expect(newChip.selected, isTrue);

    await disposeTestApp(tester);
  });

  testWidgets('gastos por etiqueta muestra el desglose y filtra por grupo', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);
    await addExpense(tester, amount: '50', destination: 'Gasolina', tag: 'Comida');
    await tester.pump(const Duration(seconds: 5));
    await addExpense(
      tester,
      amount: '30',
      destination: Strings.unexpectedLabel,
    );

    await tester.tap(find.byTooltip(Strings.tagStatisticsTitle));
    await tester.pumpAndSettle();

    expect(find.text(Strings.tagBreakdownTitle), findsOneWidget);
    expect(find.text(Strings.amountWithShare('Bs 50', '63%')), findsOneWidget);
    expect(find.text(Strings.untaggedLabel), findsOneWidget);
    expect(find.text(Strings.amountWithShare('Bs 30', '38%')), findsOneWidget);
    expect(find.text(Strings.tagTrendTitle), findsOneWidget);

    await tapVisible(
      tester,
      find.widgetWithText(ChoiceChip, Strings.unexpectedSectionTitle),
    );

    expect(find.text(Strings.amountWithShare('Bs 30', '100%')), findsOneWidget);
    expect(find.text(Strings.amountWithShare('Bs 50', '63%')), findsNothing);

    await disposeTestApp(tester);
  });

  testWidgets('renombrar y eliminar etiquetas desde ajustes', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(Strings.settingsTitle));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.tagsTitle));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Comida'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Almuerzos');
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();
    expect(find.text('Almuerzos'), findsOneWidget);
    expect(find.text('Comida'), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Bebidas'),
        matching: find.byIcon(Icons.delete_outline),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(Strings.deleteTagBody), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, Strings.delete));
    await tester.pumpAndSettle();

    expect(find.text('Bebidas'), findsNothing);
    expect(find.text('Almuerzos'), findsOneWidget);

    await disposeTestApp(tester);
  });
}
