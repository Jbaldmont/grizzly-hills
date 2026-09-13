import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/expenses/expense_repository.dart';
import 'package:grizzly_hills/features/expenses/month_overview.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';

void main() {
  late AppDatabase db;
  late MonthRepository months;
  late ExpenseRepository expenses;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    months = MonthRepository(db);
    expenses = ExpenseRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<ActiveMonth> openMonth() async {
    await months.startMonth(
      date: DateTime(2026, 7, 12),
      salaryCents: 300000,
      groups: const [
        GroupDraft(name: 'Casa', budgetCents: 50000),
        GroupDraft(name: 'Gasolina', budgetCents: 17000),
      ],
    );
    return (await months.watchActiveMonth().first)!;
  }

  test('siembra las 3 plantillas de fijos', () async {
    final templates = await expenses.watchFixedTemplates().first;

    expect(templates.map((t) => t.name), [
      'Corte de pelo',
      'Suscripción Claude',
      'Natación Ale',
    ]);
    expect(templates.every((t) => t.lastAmountCents == 0), isTrue);
  });

  test('un gasto de grupo suma en su grupo y no toca el general', () async {
    final month = await openMonth();
    final casa = month.groups.first;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.group,
      groupId: casa.id,
      description: 'Mercado',
      amountCents: 12000,
      date: DateTime(2026, 7, 12),
    );

    final overview = MonthOverview(
      activeMonth: month,
      expenses: await expenses.watchExpenses(month.month.id).first,
    );
    expect(overview.spentInGroupCents(casa.id), 12000);
    expect(overview.spentInGroupCents(month.groups.last.id), 0);
    expect(overview.availableGeneralCents, 233000);
  });

  test('fijos e imprevistos descuentan del disponible general', () async {
    final month = await openMonth();
    final template = (await expenses.watchFixedTemplates().first).first;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.fixed,
      description: template.name,
      amountCents: 3000,
      date: DateTime(2026, 7, 12),
      fixedTemplateId: template.id,
    );
    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.unexpected,
      description: 'Llanta pinchada',
      amountCents: 8000,
      date: DateTime(2026, 7, 12),
    );

    final overview = MonthOverview(
      activeMonth: month,
      expenses: await expenses.watchExpenses(month.month.id).first,
    );
    expect(overview.fixedCents, 3000);
    expect(overview.unexpectedCents, 8000);
    expect(overview.availableGeneralCents, 233000 - 3000 - 8000);
  });

  test('pagar un fijo recuerda el monto en la plantilla', () async {
    final month = await openMonth();
    final template = (await expenses.watchFixedTemplates().first).first;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.fixed,
      description: template.name,
      amountCents: 3500,
      date: DateTime(2026, 7, 12),
      fixedTemplateId: template.id,
    );

    final updated = (await expenses.watchFixedTemplates().first).first;
    expect(updated.lastAmountCents, 3500);
  });

  test('devolver extensión reduce las más recientes y borra las vacías', () async {
    final month = await openMonth();
    final casa = month.groups.first;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.budgetExtension,
      groupId: casa.id,
      description: 'Extensión: Casa',
      amountCents: 3000,
      date: DateTime(2026, 7, 10),
    );
    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.budgetExtension,
      groupId: casa.id,
      description: 'Extensión: Casa',
      amountCents: 2000,
      date: DateTime(2026, 7, 12),
    );

    await expenses.returnExtension(groupId: casa.id, amountCents: 4000);

    final remaining = await expenses.watchExpenses(month.month.id).first;
    expect(remaining.length, 1);
    expect(remaining.single.amountCents, 1000);
    expect(remaining.single.date, DateTime(2026, 7, 10));

    final overview = MonthOverview(activeMonth: month, expenses: remaining);
    expect(overview.extensionCentsForGroup(casa.id), 1000);
    expect(overview.unexpectedCents, 1000);
  });

  test('un gasto con extensión registra ambas filas en una sola operación',
      () async {
    final month = await openMonth();
    final casa = month.groups.first;

    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.group,
      groupId: casa.id,
      description: 'Mercado grande',
      amountCents: 56000,
      date: DateTime(2026, 7, 12),
      extensionRequest: const ExtensionRequest(
        amountCents: 6000,
        description: 'Extensión: Casa',
      ),
    );

    final rows = await expenses.loadExpenses(month.month.id);
    expect(rows.length, 2);
    final overview = MonthOverview(activeMonth: month, expenses: rows);
    expect(overview.spentInGroupCents(casa.id), 56000);
    expect(overview.extensionCentsForGroup(casa.id), 6000);
    expect(overview.unexpectedCents, 6000);
  });

  test('editar un gasto puede otorgar la extensión en la misma operación',
      () async {
    final month = await openMonth();
    final casa = month.groups.first;
    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.group,
      groupId: casa.id,
      description: 'Mercado',
      amountCents: 40000,
      date: DateTime(2026, 7, 12),
    );
    final created =
        (await expenses.loadExpenses(month.month.id)).single;

    await expenses.updateExpense(
      id: created.id,
      description: 'Mercado',
      amountCents: 56000,
      date: DateTime(2026, 7, 13),
      extensionRequest: const ExtensionRequest(
        amountCents: 6000,
        description: 'Extensión: Casa',
      ),
    );

    final rows = await expenses.loadExpenses(month.month.id);
    expect(rows.length, 2);
    final overview = MonthOverview(activeMonth: month, expenses: rows);
    expect(overview.spentInGroupCents(casa.id), 56000);
    expect(overview.extensionCentsForGroup(casa.id), 6000);
  });

  test('editar y borrar un gasto', () async {
    final month = await openMonth();
    await expenses.addExpense(
      monthId: month.month.id,
      kind: ExpenseKind.unexpected,
      description: 'Original',
      amountCents: 1000,
      date: DateTime(2026, 7, 10),
    );
    final created =
        (await expenses.watchExpenses(month.month.id).first).single;

    await expenses.updateExpense(
      id: created.id,
      description: 'Corregido',
      amountCents: 2500,
      date: DateTime(2026, 7, 11),
    );
    final updated =
        (await expenses.watchExpenses(month.month.id).first).single;
    expect(updated.description, 'Corregido');
    expect(updated.amountCents, 2500);

    await expenses.deleteExpense(updated.id);
    expect(await expenses.watchExpenses(month.month.id).first, isEmpty);
  });
}
