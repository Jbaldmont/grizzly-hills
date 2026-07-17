import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart';

enum ExpenseKind { group, fixed, unexpected }

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

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get monthId =>
      integer().references(Months, #id, onDelete: KeyAction.cascade)();

  IntColumn get groupId => integer().nullable().references(
    BudgetGroups,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get fixedTemplateId => integer().nullable().references(
    FixedExpenseTemplates,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get kind => textEnum<ExpenseKind>()();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
}

class FixedExpenseTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get lastAmountCents => integer().withDefault(const Constant(0))();
  IntColumn get position => integer()();
}

class SavingsLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  IntColumn get position => integer()();
}

const List<(String, int)> _defaultTemplates = [
  ('Agua, Luz y Teléfonos', 50000),
  ('Gastos Míos', 50000),
  ('Gastos para Casa', 50000),
  ('Leches', 18000),
  ('Gasolina', 17000),
];

const List<String> _defaultFixedTemplates = [
  'Corte de pelo',
  'Suscripción Claude',
  'Natación Ale',
];

@DriftDatabase(
  tables: [
    Months,
    BudgetGroups,
    GroupTemplates,
    Expenses,
    FixedExpenseTemplates,
    SavingsLocations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'grizzly_hills'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await batch(_seedTemplates);
      await batch(_seedFixedTemplates);
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(expenses);
        await migrator.createTable(fixedExpenseTemplates);
        await batch(_seedFixedTemplates);
      }
      if (from < 3) {
        await migrator.createTable(savingsLocations);
      }
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

  void _seedFixedTemplates(Batch batch) {
    batch.insertAll(fixedExpenseTemplates, [
      for (var i = 0; i < _defaultFixedTemplates.length; i++)
        FixedExpenseTemplatesCompanion.insert(
          name: _defaultFixedTemplates[i],
          position: i,
        ),
    ]);
  }
}
