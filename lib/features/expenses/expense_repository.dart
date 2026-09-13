import 'dart:math';

import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';

class ExtensionRequest {
  const ExtensionRequest({required this.amountCents, required this.description});

  final int amountCents;
  final String description;
}

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
    ExtensionRequest? extensionRequest,
  }) {
    return _db.transaction(() async {
      if (extensionRequest != null && groupId != null) {
        await _insertExtension(monthId, groupId, extensionRequest);
      }
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
    ExtensionRequest? extensionRequest,
  }) {
    return _db.transaction(() async {
      if (extensionRequest != null) {
        final expense = await (_db.select(
          _db.expenses,
        )..where((row) => row.id.equals(id))).getSingle();
        final groupId = expense.groupId;
        if (groupId != null) {
          await _insertExtension(expense.monthId, groupId, extensionRequest);
        }
      }
      await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
        ExpensesCompanion(
          description: Value(description),
          amountCents: Value(amountCents),
          date: Value(date),
        ),
      );
    });
  }

  Future<void> deleteExpense(int id) {
    return (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
  }

  Future<void> returnExtension({
    required int groupId,
    required int amountCents,
  }) {
    return _db.transaction(() async {
      final extensionRows =
          await (_db.select(_db.expenses)
                ..where(
                  (expense) =>
                      expense.groupId.equals(groupId) &
                      expense.kind.equalsValue(ExpenseKind.budgetExtension),
                )
                ..orderBy([
                  (expense) => OrderingTerm.desc(expense.date),
                  (expense) => OrderingTerm.desc(expense.id),
                ]))
              .get();
      var remainingCents = amountCents;
      for (final extensionRow in extensionRows) {
        if (remainingCents <= 0) {
          break;
        }
        final reduceCents = min(extensionRow.amountCents, remainingCents);
        if (reduceCents == extensionRow.amountCents) {
          await (_db.delete(
            _db.expenses,
          )..where((expense) => expense.id.equals(extensionRow.id))).go();
        } else {
          await (_db.update(
            _db.expenses,
          )..where((expense) => expense.id.equals(extensionRow.id))).write(
            ExpensesCompanion(
              amountCents: Value(extensionRow.amountCents - reduceCents),
            ),
          );
        }
        remainingCents -= reduceCents;
      }
    });
  }

  Future<void> _insertExtension(
    int monthId,
    int groupId,
    ExtensionRequest extensionRequest,
  ) {
    return _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            monthId: monthId,
            groupId: Value(groupId),
            kind: ExpenseKind.budgetExtension,
            description: extensionRequest.description,
            amountCents: extensionRequest.amountCents,
            date: dateOnly(DateTime.now()),
          ),
        );
  }

  Future<void> _rememberFixedAmount(int templateId, int amountCents) {
    return (_db.update(_db.fixedExpenseTemplates)
          ..where((t) => t.id.equals(templateId)))
        .write(
      FixedExpenseTemplatesCompanion(lastAmountCents: Value(amountCents)),
    );
  }
}
