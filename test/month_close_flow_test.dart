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

  Future<void> addSavingsLocation(WidgetTester tester, String name) async {
    await tester.tap(find.text(Strings.tabSavings));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.addLocationCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), name);
    await tester.tap(find.text(Strings.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.tabHome));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'cerrar el mes con sobrante lo transfiere y lo deja en el historial',
    (tester) async {
      await tester.pumpWidget(await buildTestApp(db));
      await tester.pumpAndSettle();
      await openTestMonth(tester);
      await addSavingsLocation(tester, 'Caja roja');

      await tester.scrollUntilVisible(
        find.text(Strings.closeMonthCta),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(Strings.closeMonthCta));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Caja roja'));
      await tester.pump();
      await tester.tap(
        find.widgetWithText(FilledButton, Strings.closeMonthCta),
      );
      await tester.pumpAndSettle();

      expect(find.text(Strings.closeMonthDoneMessage), findsOneWidget);
      expect(find.text(Strings.homeEmptyTitle), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.text(Strings.monthHistoryTitle), findsOneWidget);
      expect(find.text('Bs 3.000'), findsOneWidget);

      await disposeTestApp(tester);
    },
  );

  testWidgets(
    'el detalle de un mes cerrado es de solo lectura',
    (tester) async {
      await tester.pumpWidget(await buildTestApp(db));
      await tester.pumpAndSettle();
      await openTestMonth(tester);
      await addSavingsLocation(tester, 'Caja roja');

      await tester.scrollUntilVisible(
        find.text(Strings.closeMonthCta),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(Strings.closeMonthCta));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Caja roja'));
      await tester.pump();
      await tester.tap(
        find.widgetWithText(FilledButton, Strings.closeMonthCta),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_outlined), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);

      await tester.tap(find.text('Agua, Luz y Teléfonos').first);
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.text(Strings.requestExtension), findsNothing);

      await disposeTestApp(tester);
    },
  );
}
