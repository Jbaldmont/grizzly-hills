import 'package:drift/drift.dart';
import '../../core/db/app_database.dart';

class ActiveMonth {
  const ActiveMonth({required this.month, required this.groups});

  final Month month;
  final List<BudgetGroup> groups;

  int get assignedCents =>
      groups.fold(0, (sum, group) => sum + group.budgetCents);

  int get generalBudgetCents => month.salaryCents - assignedCents;
}

class GroupDraft {
  const GroupDraft({required this.name, required this.budgetCents});

  final String name;
  final int budgetCents;
}

class MonthRepository {
  MonthRepository(this._db);

  final AppDatabase _db;

  Stream<ActiveMonth?> watchActiveMonth() {
    final query =
        _db.select(_db.months).join([
            leftOuterJoin(
              _db.budgetGroups,
              _db.budgetGroups.monthId.equalsExp(_db.months.id),
            ),
          ])
          ..where(_db.months.closedAt.isNull())
          ..orderBy([
            OrderingTerm.desc(_db.months.createdAt),
            OrderingTerm.asc(_db.budgetGroups.position),
          ]);

    return query.watch().map(_mapRowsToActiveMonth);
  }

  Future<List<GroupTemplate>> loadTemplates() {
    final query = _db.select(_db.groupTemplates)
      ..orderBy([(template) => OrderingTerm.asc(template.position)]);
    return query.get();
  }

  Future<void> startMonth({
    required DateTime date,
    required int salaryCents,
    required List<GroupDraft> groups,
  }) {
    return _db.transaction(() async {
      final monthId = await _db
          .into(_db.months)
          .insert(
            MonthsCompanion.insert(
              year: date.year,
              month: date.month,
              salaryCents: salaryCents,
            ),
          );
      await _db.batch((batch) {
        batch.insertAll(_db.budgetGroups, [
          for (var i = 0; i < groups.length; i++)
            BudgetGroupsCompanion.insert(
              monthId: monthId,
              name: groups[i].name,
              budgetCents: groups[i].budgetCents,
              position: i,
            ),
        ]);
      });
    });
  }

  Future<void> updateMonth({
    required int monthId,
    required int salaryCents,
    required Map<int, int> groupBudgetsCents,
  }) {
    return _db.transaction(() async {
      await (_db.update(_db.months)..where((m) => m.id.equals(monthId))).write(
        MonthsCompanion(salaryCents: Value(salaryCents)),
      );
      for (final entry in groupBudgetsCents.entries) {
        await (_db.update(_db.budgetGroups)
              ..where((g) => g.id.equals(entry.key)))
            .write(BudgetGroupsCompanion(budgetCents: Value(entry.value)));
      }
    });
  }

  ActiveMonth? _mapRowsToActiveMonth(List<TypedResult> rows) {
    if (rows.isEmpty) {
      return null;
    }
    final month = rows.first.readTable(_db.months);
    final groups = [
      for (final row in rows)
        if (row.readTable(_db.months).id == month.id)
          row.readTableOrNull(_db.budgetGroups),
    ].whereType<BudgetGroup>().toList();
    return ActiveMonth(month: month, groups: groups);
  }
}
