import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

class ExpenseRepository {
  ExpenseRepository(this._db);

  final AppDatabase _db;

  Stream<List<Expense>> watchExpenses(int monthId) {
    final query = _db.select(_db.expenses)
      ..where((expense) => expense.monthId.equals(monthId))
      ..orderBy([
        (expense) => OrderingTerm.desc(expense.date),
        (expense) => OrderingTerm.desc(expense.id),
      ]);
    return query.watch();
  }

  Future<List<Expense>> loadExpenses(int monthId) {
    final query = _db.select(_db.expenses)
      ..where((expense) => expense.monthId.equals(monthId));
    return query.get();
  }

  Stream<List<FixedExpenseTemplate>> watchFixedTemplates() {
    final query = _db.select(_db.fixedExpenseTemplates)
      ..orderBy([(template) => OrderingTerm.asc(template.position)]);
    return query.watch();
  }

  Future<void> addExpense({
    required int monthId,
    required ExpenseKind kind,
    required String description,
    required int amountCents,
    required DateTime date,
    int? groupId,
    int? fixedTemplateId,
  }) {
    return _db.transaction(() async {
      await _db.into(_db.expenses).insert(
            ExpensesCompanion.insert(
              monthId: monthId,
              groupId: Value(groupId),
              fixedTemplateId: Value(fixedTemplateId),
              kind: kind,
              description: description,
              amountCents: amountCents,
              date: date,
            ),
          );
      if (fixedTemplateId != null) {
        await _rememberFixedAmount(fixedTemplateId, amountCents);
      }
    });
  }

  Future<void> updateExpense({
    required int id,
    required String description,
    required int amountCents,
    required DateTime date,
  }) {
    return (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
      ExpensesCompanion(
        description: Value(description),
        amountCents: Value(amountCents),
        date: Value(date),
      ),
    );
  }

  Future<void> deleteExpense(int id) {
    return (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
  }

  Future<void> _rememberFixedAmount(int templateId, int amountCents) {
    return (_db.update(_db.fixedExpenseTemplates)
          ..where((t) => t.id.equals(templateId)))
        .write(
      FixedExpenseTemplatesCompanion(lastAmountCents: Value(amountCents)),
    );
  }
}
