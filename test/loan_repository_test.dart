import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/loans/loan_interest.dart';
import 'package:grizzly_hills/features/loans/loan_repository.dart';

void main() {
  late AppDatabase db;
  late LoanRepository loans;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    loans = LoanRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<Loan> createLoan({int principalCents = 10000}) async {
    await loans.addLoan(
      debtorName: 'Carlos',
      principalCents: principalCents,
      loanDate: DateTime(2026, 7, 1),
      dueDate: DateTime(2026, 7, 15),
    );
    return (await loans.watchActiveLoans().first).single;
  }

  test('crear, editar y eliminar un préstamo', () async {
    final loan = await createLoan();
    expect(loan.debtorName, 'Carlos');
    expect(loan.principalCents, 10000);
    expect(loan.interestStartDate, DateTime(2026, 7, 1));

    await loans.updateLoan(
      id: loan.id,
      debtorName: 'Carlos M.',
      dueDate: DateTime(2026, 7, 22),
    );
    final updated = (await loans.watchActiveLoans().first).single;
    expect(updated.debtorName, 'Carlos M.');
    expect(updated.dueDate, DateTime(2026, 7, 22));
    expect(updated.principalCents, 10000);

    expect(await loans.deleteLoan(loan.id), isTrue);
    expect(await loans.watchActiveLoans().first, isEmpty);
  });

  test(
    'pago parcial: el remanente es la nueva base y el interés se reinicia',
    () async {
      final loan = await createLoan();

      final closed = await loans.registerPayment(
        loanId: loan.id,
        amountCents: 5000,
        date: DateTime(2026, 7, 15),
      );

      expect(closed, isFalse);
      final updated = (await loans.watchActiveLoans().first).single;
      expect(updated.principalCents, 5200);
      expect(updated.interestStartDate, DateTime(2026, 7, 15));
      expect(updated.closedAt, isNull);

      final payment = (await loans.watchPayments(loan.id).first).single;
      expect(payment.amountCents, 5000);
      expect(payment.date, DateTime(2026, 7, 15));
    },
  );

  test('el interés sigue corriendo después de la fecha tentativa', () async {
    final loan = await createLoan();

    expect(totalOwedCents(loan, DateTime(2026, 7, 29)), 10400);
    expect(isOverdue(loan, DateTime(2026, 7, 29)), isTrue);
    expect(isOverdue(loan, DateTime(2026, 7, 15)), isFalse);
  });

  test('un pago que cubre el total cierra el préstamo', () async {
    final loan = await createLoan();

    final closed = await loans.registerPayment(
      loanId: loan.id,
      amountCents: 10200,
      date: DateTime(2026, 7, 15),
    );

    expect(closed, isTrue);
    expect(await loans.watchActiveLoans().first, isEmpty);
    final closedLoan = (await loans.watchClosedLoans().first).single;
    expect(closedLoan.principalCents, 0);
    expect(closedLoan.closedAt, DateTime(2026, 7, 15));
  });

  test('no permite eliminar un préstamo con pagos', () async {
    final loan = await createLoan();
    await loans.registerPayment(
      loanId: loan.id,
      amountCents: 2000,
      date: DateTime(2026, 7, 8),
    );

    final deleted = await loans.deleteLoan(loan.id);

    expect(deleted, isFalse);
    expect((await loans.watchActiveLoans().first).single.id, loan.id);
    expect((await loans.watchPayments(loan.id).first).length, 1);
  });

  test('el total pagado por préstamo suma sus pagos', () async {
    final loan = await createLoan();
    await loans.registerPayment(
      loanId: loan.id,
      amountCents: 2000,
      date: DateTime(2026, 7, 8),
    );
    await loans.registerPayment(
      loanId: loan.id,
      amountCents: 3000,
      date: DateTime(2026, 7, 10),
    );

    final totals = await loans.watchTotalPaidByLoan().first;
    expect(totals[loan.id], 5000);
  });
}
