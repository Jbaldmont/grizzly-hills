import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/expenses/expense_repository.dart';
import 'package:grizzly_hills/features/tags/tag_repository.dart';

const _schemaV6 = [
  'CREATE TABLE "savings_locations" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "name" TEXT NOT NULL, "balance_cents" INTEGER NOT NULL '
      'DEFAULT 0, "position" INTEGER NOT NULL)',
  'CREATE TABLE "months" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"year" INTEGER NOT NULL, "month" INTEGER NOT NULL, "salary_cents" '
      'INTEGER NOT NULL, "created_at" INTEGER NOT NULL DEFAULT '
      "(CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), \"closed_at\" "
      'INTEGER NULL, "closing_transfer_cents" INTEGER NULL, '
      '"closing_savings_location_id" INTEGER NULL REFERENCES '
      'savings_locations (id) ON DELETE SET NULL, UNIQUE ("year", "month"))',
  'CREATE TABLE "budget_groups" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "month_id" INTEGER NOT NULL REFERENCES months (id) ON '
      'DELETE CASCADE, "name" TEXT NOT NULL, "budget_cents" INTEGER NOT NULL, '
      '"position" INTEGER NOT NULL)',
  'CREATE TABLE "group_templates" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "name" TEXT NOT NULL, "budget_cents" INTEGER NOT NULL, '
      '"position" INTEGER NOT NULL)',
  'CREATE TABLE "fixed_expense_templates" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "name" TEXT NOT NULL, "last_amount_cents" INTEGER NOT '
      'NULL DEFAULT 0, "position" INTEGER NOT NULL)',
  'CREATE TABLE "expenses" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"month_id" INTEGER NOT NULL REFERENCES months (id) ON DELETE CASCADE, '
      '"group_id" INTEGER NULL REFERENCES budget_groups (id) ON DELETE '
      'CASCADE, "fixed_template_id" INTEGER NULL REFERENCES '
      'fixed_expense_templates (id) ON DELETE SET NULL, "kind" TEXT NOT NULL, '
      '"description" TEXT NOT NULL, "amount_cents" INTEGER NOT NULL, "date" '
      'INTEGER NOT NULL)',
  'CREATE TABLE "loans" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"debtor_name" TEXT NOT NULL, "principal_cents" INTEGER NOT NULL, '
      '"weekly_rate_percent" REAL NOT NULL DEFAULT 1.0, "loan_date" INTEGER '
      'NOT NULL, "interest_start_date" INTEGER NOT NULL, "due_date" INTEGER '
      'NOT NULL, "closed_at" INTEGER NULL, "created_at" INTEGER NOT NULL '
      "DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)))",
  'CREATE TABLE "loan_payments" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "loan_id" INTEGER NOT NULL REFERENCES loans (id) ON '
      'DELETE CASCADE, "amount_cents" INTEGER NOT NULL, "date" INTEGER NOT '
      'NULL)',
];

const _existingData = [
  'INSERT INTO months (id, year, month, salary_cents) VALUES (1, 2026, 9, '
      '300000)',
  "INSERT INTO budget_groups (id, month_id, name, budget_cents, position) "
      "VALUES (1, 1, 'Gastos Míos', 50000, 0)",
  "INSERT INTO expenses (id, month_id, group_id, kind, description, "
      "amount_cents, date) VALUES (1, 1, 1, 'group', 'Almuerzo', 2500, "
      '1788000000)',
];

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          for (final statement in [..._schemaV6, ..._existingData]) {
            rawDatabase.execute(statement);
          }
          rawDatabase.userVersion = 6;
        },
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('migra de v6 a v7 sin perder gastos y siembra las etiquetas', () async {
    final tags = TagRepository(db);

    final seededTags = await tags.loadTags();
    final expenses = await ExpenseRepository(db).loadExpenses(1);

    expect(seededTags.map((tag) => tag.name), ['Bebidas', 'Comida']);
    expect(expenses.single.description, 'Almuerzo');
    expect(expenses.single.amountCents, 2500);
    expect(expenses.single.tagId, isNull);
  });

  test('tras migrar, la columna nueva acepta etiquetas y se limpia al '
      'borrarlas', () async {
    final tags = TagRepository(db);
    final expenseRepository = ExpenseRepository(db);
    final comida = (await tags.loadTags()).last;
    final expense = (await expenseRepository.loadExpenses(1)).single;

    await expenseRepository.updateExpense(
      id: expense.id,
      description: expense.description,
      amountCents: expense.amountCents,
      date: expense.date,
      tagId: comida.id,
    );
    expect((await expenseRepository.loadExpenses(1)).single.tagId, comida.id);

    await tags.deleteTag(comida.id);
    expect((await expenseRepository.loadExpenses(1)).single.tagId, isNull);
  });
}
