import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import 'tag_statistics.dart';

class TagRepository {
  TagRepository(this._db);

  final AppDatabase _db;

  Stream<List<ExpenseTag>> watchTags() => _tagsQuery().watch();

  Future<List<ExpenseTag>> loadTags() => _tagsQuery().get();

  Future<int> addTag(String name) {
    return _db
        .into(_db.expenseTags)
        .insert(ExpenseTagsCompanion.insert(name: name));
  }

  Future<void> renameTag({required int id, required String name}) {
    return (_db.update(_db.expenseTags)..where((tag) => tag.id.equals(id)))
        .write(ExpenseTagsCompanion(name: Value(name)));
  }

  Future<void> deleteTag(int id) {
    return (_db.delete(
      _db.expenseTags,
    )..where((tag) => tag.id.equals(id))).go();
  }

  Future<List<SpendingEntry>> loadSpendingEntries() async {
    final query =
        _db.select(_db.expenses).join([
            leftOuterJoin(
              _db.budgetGroups,
              _db.budgetGroups.id.equalsExp(_db.expenses.groupId),
            ),
          ])
          ..where(
            _db.expenses.kind.isInValues(const [
              ExpenseKind.group,
              ExpenseKind.unexpected,
            ]),
          )
          ..orderBy([OrderingTerm.asc(_db.budgetGroups.position)]);
    final rows = await query.get();
    return [for (final row in rows) _toSpendingEntry(row)];
  }

  SpendingEntry _toSpendingEntry(TypedResult row) {
    final expense = row.readTable(_db.expenses);
    return SpendingEntry(
      monthId: expense.monthId,
      amountCents: expense.amountCents,
      groupName: row.readTableOrNull(_db.budgetGroups)?.name,
      tagId: expense.tagId,
    );
  }

  SimpleSelectStatement<$ExpenseTagsTable, ExpenseTag> _tagsQuery() {
    return _db.select(_db.expenseTags)..orderBy([
      (tag) => OrderingTerm.asc(tag.name.collate(Collate.noCase)),
    ]);
  }
}
