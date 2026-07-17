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

  Future<ActiveMonth?> loadActiveMonth(int monthId) async {
    final month = await (_db.select(
      _db.months,
    )..where((row) => row.id.equals(monthId))).getSingleOrNull();
    if (month == null) {
      return null;
    }
    final groups =
        await (_db.select(_db.budgetGroups)
              ..where((budgetGroup) => budgetGroup.monthId.equals(monthId))
              ..orderBy([
                (budgetGroup) => OrderingTerm.asc(budgetGroup.position),
              ]))
            .get();
    return ActiveMonth(month: month, groups: groups);
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

  Future<void> transferBetweenGroups({
    required int sourceGroupId,
    required int targetGroupId,
    required int amountCents,
  }) {
    return _db.transaction(() async {
      await _shiftGroupBudget(sourceGroupId, -amountCents);
      await _shiftGroupBudget(targetGroupId, amountCents);
    });
  }

  Future<void> _shiftGroupBudget(int groupId, int deltaCents) async {
    final group = await (_db.select(
      _db.budgetGroups,
    )..where((budgetGroup) => budgetGroup.id.equals(groupId))).getSingle();
    await (_db.update(
      _db.budgetGroups,
    )..where((budgetGroup) => budgetGroup.id.equals(groupId))).write(
      BudgetGroupsCompanion(budgetCents: Value(group.budgetCents + deltaCents)),
    );
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
