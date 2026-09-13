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

  Future<void> openLoansTab(WidgetTester tester) async {
    await tester.tap(find.text(Strings.tabLoans));
    await tester.pumpAndSettle();
  }

  Future<void> createLoan(WidgetTester tester, String debtor) async {
    await tester.tap(find.text(Strings.newLoanCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), debtor);
    await tester.enterText(find.byType(TextFormField).at(1), '100');
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();
  }

  Future<void> registerPayment(WidgetTester tester, String amount) async {
    await tester.tap(find.text(Strings.registerPaymentCta));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), amount);
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();
    expect(find.text(Strings.confirmPaymentTitle), findsOneWidget);
    await tester.tap(find.text(Strings.confirm));
    await tester.pumpAndSettle();
  }

  testWidgets('crear un préstamo desde el estado vacío', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openLoansTab(tester);

    expect(find.text(Strings.loansEmptyTitle), findsOneWidget);

    await createLoan(tester, 'Carlos');

    expect(find.text('Carlos'), findsOneWidget);
    expect(find.text(Strings.loansTotalLabel), findsOneWidget);
    expect(find.text('Bs 100'), findsNWidgets(2));

    await disposeTestApp(tester);
  });

  testWidgets('un pago parcial reduce la base del préstamo', (tester) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openLoansTab(tester);
    await createLoan(tester, 'Carlos');

    await tester.tap(find.text('Carlos'));
    await tester.pumpAndSettle();
    await registerPayment(tester, '40');

    expect(find.text(Strings.paymentRegisteredMessage), findsOneWidget);
    expect(find.text('Bs 60'), findsNWidgets(2));
    expect(find.text('Bs 40'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await disposeTestApp(tester);
  });

  testWidgets('un pago total cierra el préstamo y va al historial', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(db));
    await tester.pumpAndSettle();
    await openLoansTab(tester);
    await createLoan(tester, 'Carlos');

    await tester.tap(find.text('Carlos'));
    await tester.pumpAndSettle();
    await registerPayment(tester, '100');

    expect(find.text(Strings.loanClosedMessage), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(Strings.loansEmptyTitle), findsOneWidget);

    await tester.tap(find.text(Strings.loanHistoryCta));
    await tester.pumpAndSettle();
    expect(find.text('Carlos'), findsOneWidget);
    expect(find.text('Bs 100'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await disposeTestApp(tester);
  });
}
