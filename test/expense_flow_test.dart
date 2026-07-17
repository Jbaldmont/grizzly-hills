import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/core/strings.dart';
import 'package:grizzly_hills/features/home/widgets/unexpected_card.dart';

import 'app_test_utils.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('gasto rápido en un grupo actualiza su tarjeta', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '50');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Gasolina'));
    await tester.pump();
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('${Strings.spentLabel}: Bs 50'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('${Strings.spentLabel}: Bs 50'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets(
    'un gasto que supera el grupo ofrece solicitar extensión del presupuesto general',
    (tester) async {
      await tester.pumpWidget(await buildTestApp(db));
      await tester.pumpAndSettle();
      await openTestMonth(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '200');
      await tester.tap(find.widgetWithText(ChoiceChip, 'Gasolina'));
      await tester.pump();
      await tester.tap(find.text(Strings.save));
      await tester.pumpAndSettle();

      expect(find.text(Strings.insufficientBudgetTitle), findsOneWidget);

      await tester.tap(find.text(Strings.requestExtension));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('${Strings.spentLabel}: Bs 200'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('${Strings.spentLabel}: Bs 200'), findsOneWidget);
      expect(find.text('${Strings.remainingLabel} Bs 0'), findsOneWidget);
      expect(
        find.text(Strings.budgetWithExtension('Bs 170', 'Bs 30')),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.byType(UnexpectedCard),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byType(UnexpectedCard));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(UnexpectedCard));
      await tester.pumpAndSettle();

      final extensionTile = find.text(Strings.extensionDescription('Gasolina'));
      expect(extensionTile, findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);

      await tester.drag(extensionTile, const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(extensionTile, findsOneWidget);

      await disposeTestApp(tester);
    },
  );

  testWidgets('pagar un fijo lo marca con su monto', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await tester.scrollUntilVisible(
      find.text('Corte de pelo'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Corte de pelo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Corte de pelo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '30');
    await tester.tap(find.text(Strings.pay));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Bs 30'), findsWidgets);

    await disposeTestApp(tester);
  });

  testWidgets('un imprevisto descuenta del disponible general', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '150');
    await tester.tap(
      find.widgetWithText(ChoiceChip, Strings.unexpectedLabel),
    );
    await tester.pump();
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    expect(find.text('Bs 1.000'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('la lista de imprevistos permite borrar un gasto', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openTestMonth(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '150');
    await tester.tap(
      find.widgetWithText(ChoiceChip, Strings.unexpectedLabel),
    );
    await tester.pump();
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byType(UnexpectedCard),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byType(UnexpectedCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(UnexpectedCard));
    await tester.pumpAndSettle();

    await tester.drag(find.text(Strings.noDescription), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.delete));
    await tester.pumpAndSettle();

    expect(find.text(Strings.noExpensesYet), findsOneWidget);

    await disposeTestApp(tester);
  });
}
