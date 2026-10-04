import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/expenses/expense_repository.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';
import 'package:grizzly_hills/features/tags/tag_repository.dart';

void main() {
  late AppDatabase db;
  late MonthRepository months;
  late ExpenseRepository expenses;
  late TagRepository tags;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    months = MonthRepository(db);
    expenses = ExpenseRepository(db);
    tags = TagRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<ActiveMonth> openMonth() async {
    await months.startMonth(
      date: DateTime(2026, 9, 1),
      salaryCents: 300000,
      groups: const [
        GroupDraft(name: 'Casa', budgetCents: 50000),
        GroupDraft(name: 'Gastos Míos', budgetCents: 50000),
      ],
    );
    return (await months.loadCurrentActiveMonth())!;
  }

  Future<List<Expense>> loadAllExpenses(int monthId) =>
      expenses.loadExpenses(monthId);

  test('siembra Comida y Bebidas ordenadas por nombre', () async {
    final seeded = await tags.loadTags();

    expect(seeded.map((tag) => tag.name), ['Bebidas', 'Comida']);
  });

  test('crea y renombra etiquetas manteniendo el orden alfabético', () async {
    final tagId = await tags.addTag('antojos');
    await tags.renameTag(id: tagId, name: 'Salidas');

    final names = (await tags.loadTags()).map((tag) => tag.name);
    expect(names, ['Bebidas', 'Comida', 'Salidas']);
  });

  test('guarda la etiqueta al crear y editar un gasto', () async {
    final month = await openMonth();
    final comida = (await tags.loadTags()).last;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.group,
      groupId: month.groups.first.id,
      description: 'Almuerzo',
      amountCents: 2500,
      date: DateTime(2026, 9, 2),
      tagId: comida.id,
    );
    final created = (await loadAllExpenses(month.month.id)).single;
    expect(created.tagId, comida.id);

    await expenses.updateExpense(
      id: created.id,
      description: created.description,
      amountCents: created.amountCents,
      date: created.date,
    );
    expect((await loadAllExpenses(month.month.id)).single.tagId, isNull);
  });

  test('eliminar una etiqueta deja sus gastos sin etiqueta', () async {
    final month = await openMonth();
    final comida = (await tags.loadTags()).last;
    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.unexpected,
      description: 'Pizza',
      amountCents: 8000,
      date: DateTime(2026, 9, 3),
      tagId: comida.id,
    );

    await tags.deleteTag(comida.id);

    final expense = (await loadAllExpenses(month.month.id)).single;
    expect(expense.tagId, isNull);
    expect(expense.amountCents, 8000);
    expect((await tags.loadTags()).map((tag) => tag.name), ['Bebidas']);
  });

  test(
    'las estadísticas solo incluyen gastos de grupo e imprevistos',
    () async {
      final month = await openMonth();
      final monthId = month.month.id;
      final gastosMios = month.groups.last;
      final comida = (await tags.loadTags()).last;
      await expenses.addExpense(
        monthId: monthId,
        kind: ExpenseKind.group,
        groupId: gastosMios.id,
        description: 'Salteñas',
        amountCents: 3000,
        date: DateTime(2026, 9, 2),
        tagId: comida.id,
      );
      await expenses.addExpense(
        monthId: monthId,
        kind: ExpenseKind.unexpected,
        description: 'Farmacia',
        amountCents: 4000,
        date: DateTime(2026, 9, 2),
      );
      await expenses.addExpense(
        monthId: monthId,
        kind: ExpenseKind.budgetExtension,
        groupId: gastosMios.id,
        description: 'Extensión: Gastos Míos',
        amountCents: 10000,
        date: DateTime(2026, 9, 2),
      );
      await expenses.addExpense(
        monthId: monthId,
        kind: ExpenseKind.savingsTransfer,
        groupId: gastosMios.id,
        description: 'Transferencia a ahorro',
        amountCents: 5000,
        date: DateTime(2026, 9, 2),
      );

      final entries = await tags.loadSpendingEntries();

      expect(entries, hasLength(2));
      final tagged = entries.singleWhere((entry) => entry.tagId != null);
      expect(tagged.groupName, 'Gastos Míos');
      expect(tagged.amountCents, 3000);
      final unexpected = entries.singleWhere((entry) => entry.tagId == null);
      expect(unexpected.groupName, isNull);
      expect(unexpected.monthId, monthId);
    },
  );

  test(
    'loadAllMonths devuelve los meses del más reciente al más antiguo',
    () async {
      await months.startMonth(
        date: DateTime(2026, 8, 1),
        salaryCents: 100000,
        groups: const [],
      );
      final august = (await months.loadCurrentActiveMonth())!;
      await months.closeMonth(monthId: august.month.id, surplusCents: 0);
      await months.startMonth(
        date: DateTime(2026, 9, 1),
        salaryCents: 100000,
        groups: const [],
      );

      final all = await months.loadAllMonths();

      expect(all.map((month) => month.month), [9, 8]);
    },
  );
}
