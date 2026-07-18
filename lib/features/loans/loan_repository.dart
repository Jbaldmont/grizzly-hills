import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import 'loan_interest.dart';

class LoanRepository {
  LoanRepository(this._db);

  final AppDatabase _db;

  Stream<List<Loan>> watchActiveLoans() {
    final query = _db.select(_db.loans)
      ..where((loan) => loan.closedAt.isNull())
      ..orderBy([(loan) => OrderingTerm.asc(loan.dueDate)]);
    return query.watch();
  }

  Stream<List<Loan>> watchClosedLoans() {
    final query = _db.select(_db.loans)
      ..where((loan) => loan.closedAt.isNotNull())
      ..orderBy([(loan) => OrderingTerm.desc(loan.closedAt)]);
    return query.watch();
  }

  Stream<Loan?> watchLoan(int id) {
    final query = _db.select(_db.loans)..where((loan) => loan.id.equals(id));
    return query.watchSingleOrNull();
  }

  Stream<List<LoanPayment>> watchPayments(int loanId) {
    final query = _db.select(_db.loanPayments)
      ..where((payment) => payment.loanId.equals(loanId))
      ..orderBy([
        (payment) => OrderingTerm.desc(payment.date),
        (payment) => OrderingTerm.desc(payment.id),
      ]);
    return query.watch();
  }

  Stream<Map<int, int>> watchTotalPaidByLoan() {
    final totalPaid = _db.loanPayments.amountCents.sum();
    final query = _db.selectOnly(_db.loanPayments)
      ..addColumns([_db.loanPayments.loanId, totalPaid])
      ..groupBy([_db.loanPayments.loanId]);
    return query.watch().map(
          (rows) => {
            for (final row in rows)
              row.read(_db.loanPayments.loanId)!: row.read(totalPaid) ?? 0,
          },
        );
  }

  Future<bool> hasPayments(int loanId) async {
    final query = _db.select(_db.loanPayments)
      ..where((payment) => payment.loanId.equals(loanId))
      ..limit(1);
    final payments = await query.get();
    return payments.isNotEmpty;
  }

  Future<void> addLoan({
    required String debtorName,
    required int principalCents,
    required DateTime loanDate,
    required DateTime dueDate,
    double weeklyRatePercent = defaultWeeklyRatePercent,
  }) {
    final normalizedLoanDate = dateOnly(loanDate);
    return _db.into(_db.loans).insert(
          LoansCompanion.insert(
            debtorName: debtorName,
            principalCents: principalCents,
            weeklyRatePercent: Value(weeklyRatePercent),
            loanDate: normalizedLoanDate,
            interestStartDate: normalizedLoanDate,
            dueDate: dateOnly(dueDate),
          ),
        );
  }

  Future<void> updateLoan({
    required int id,
    required String debtorName,
    required DateTime dueDate,
    int? principalCents,
    DateTime? loanDate,
    double? weeklyRatePercent,
  }) {
    return (_db.update(_db.loans)..where((loan) => loan.id.equals(id))).write(
      LoansCompanion(
        debtorName: Value(debtorName),
        dueDate: Value(dateOnly(dueDate)),
        principalCents:
            principalCents == null ? const Value.absent() : Value(principalCents),
        loanDate:
            loanDate == null ? const Value.absent() : Value(dateOnly(loanDate)),
        interestStartDate:
            loanDate == null ? const Value.absent() : Value(dateOnly(loanDate)),
        weeklyRatePercent: weeklyRatePercent == null
            ? const Value.absent()
            : Value(weeklyRatePercent),
      ),
    );
  }

  Future<void> deleteLoan(int id) {
    return (_db.delete(_db.loans)..where((loan) => loan.id.equals(id))).go();
  }

  Future<bool> registerPayment({
    required int loanId,
    required int amountCents,
    required DateTime date,
  }) {
    final paymentDate = dateOnly(date);
    return _db.transaction(() async {
      final loan = await (_db.select(
        _db.loans,
      )..where((row) => row.id.equals(loanId))).getSingle();
      final owedCents = totalOwedCents(loan, paymentDate);
      final remainingCents = owedCents - amountCents;
      final closes = remainingCents <= 0;
      await _db.into(_db.loanPayments).insert(
            LoanPaymentsCompanion.insert(
              loanId: loanId,
              amountCents: amountCents,
              date: paymentDate,
            ),
          );
      await (_db.update(_db.loans)..where((row) => row.id.equals(loanId)))
          .write(
        LoansCompanion(
          principalCents: Value(closes ? 0 : remainingCents),
          interestStartDate: Value(paymentDate),
          closedAt: closes ? Value(paymentDate) : const Value.absent(),
        ),
      );
      return closes;
    });
  }
}
