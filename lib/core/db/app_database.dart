import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart';

class Months extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get salaryCents => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {year, month},
  ];
}

class BudgetGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get monthId =>
      integer().references(Months, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get budgetCents => integer()();
  IntColumn get position => integer()();
}

class GroupTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get budgetCents => integer()();
  IntColumn get position => integer()();
}

const List<(String, int)> _defaultTemplates = [
  ('Agua, Luz y Teléfonos', 50000),
  ('Gastos Míos', 50000),
  ('Gastos para Casa', 50000),
  ('Leches', 18000),
  ('Gasolina', 17000),
];

@DriftDatabase(tables: [Months, BudgetGroups, GroupTemplates])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'grizzly_hills'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await batch(_seedTemplates);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  void _seedTemplates(Batch batch) {
    batch.insertAll(groupTemplates, [
      for (var i = 0; i < _defaultTemplates.length; i++)
        GroupTemplatesCompanion.insert(
          name: _defaultTemplates[i].$1,
          budgetCents: _defaultTemplates[i].$2,
          position: i,
        ),
    ]);
  }
}
