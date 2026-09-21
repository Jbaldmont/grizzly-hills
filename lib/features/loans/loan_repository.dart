import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';
import '../../core/notifications/notification_scheduler.dart';
import 'loan_interest.dart';

class LoanRepository {
  LoanRepository(this._db, [NotificationScheduler? notifications])
    : _notifications = notifications ?? const NoopNotificationScheduler();

  final AppDatabase _db;
  final NotificationScheduler _notifications;

  Stream<List<Loan>> watchActiveLoans() {
    final query = _db.select(_db.loans)
      ..where((loan) => loan.closedAt.isNull())
      ..orderBy([(loan) => OrderingTerm.asc(loan.dueDate)]);
    return query.watch();
  }

  Future<List<Loan>> loadActiveLoans() {
    final query = _db.select(_db.loans)
      ..where((loan) => loan.closedAt.isNull());
    return query.get();
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
  }) async {
    final normalizedLoanDate = dateOnly(loanDate);
    final id = await _db.into(_db.loans).insert(
          LoansCompanion.insert(
            debtorName: debtorName,
            principalCents: principalCents,
            weeklyRatePercent: Value(weeklyRatePercent),
            loanDate: normalizedLoanDate,
            interestStartDate: normalizedLoanDate,
            dueDate: dateOnly(dueDate),
          ),
        );
    await _scheduleDueReminder(id);
  }

  Future<void> updateLoan({
    required int id,
    required String debtorName,
    required DateTime dueDate,
    int? principalCents,
    DateTime? loanDate,
  }) async {
    await (_db.update(_db.loans)..where((loan) => loan.id.equals(id))).write(
      LoansCompanion(
        debtorName: Value(debtorName),
        dueDate: Value(dateOnly(dueDate)),
        principalCents:
            principalCents == null ? const Value.absent() : Value(principalCents),
        loanDate:
            loanDate == null ? const Value.absent() : Value(dateOnly(loanDate)),
        interestStartDate:
            loanDate == null ? const Value.absent() : Value(dateOnly(loanDate)),
      ),
    );
    await _scheduleDueReminder(id);
  }

  Future<bool> deleteLoan(int id) async {
    final deleted = await _db.transaction(() async {
      if (await hasPayments(id)) {
        return false;
      }
      await (_db.delete(_db.loans)..where((loan) => loan.id.equals(id))).go();
      return true;
    });
    if (deleted) {
      await _notifications.cancelLoanDueReminder(id);
    }
    return deleted;
  }

  Future<bool> registerPayment({
    required int loanId,
    required int amountCents,
    required DateTime date,
  }) async {
    final paymentDate = dateOnly(date);
    final closes = await _db.transaction(() async {
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
    if (closes) {
      await _notifications.cancelLoanDueReminder(loanId);
    }
    return closes;
  }

  Future<void> _scheduleDueReminder(int loanId) async {
    final loan = await (_db.select(
      _db.loans,
    )..where((row) => row.id.equals(loanId))).getSingle();
    await _notifications.scheduleLoanDueReminder(loan);
  }
}
