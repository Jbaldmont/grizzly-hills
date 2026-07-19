import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/expenses/expense_repository.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';
import 'package:grizzly_hills/features/savings/savings_repository.dart';

void main() {
  late AppDatabase db;
  late MonthRepository months;
  late ExpenseRepository expenses;
  late SavingsRepository savings;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    months = MonthRepository(db);
    expenses = ExpenseRepository(db);
    savings = SavingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<ActiveMonth> openMonth() async {
    await months.startMonth(
      date: DateTime(2026, 7, 17),
      salaryCents: 300000,
      groups: const [
        GroupDraft(name: 'Casa', budgetCents: 50000),
        GroupDraft(name: 'Gasolina', budgetCents: 17000),
      ],
    );
    return (await months.watchActiveMonth().first)!;
  }

  test('agregar, renombrar y eliminar ubicaciones respeta el orden', () async {
    await savings.addLocation('Banco Unión');
    await savings.addLocation('Caja roja');

    var locations = await savings.loadLocations();
    expect(locations.map((location) => location.name), [
      'Banco Unión',
      'Caja roja',
    ]);
    expect(locations.every((location) => location.balanceCents == 0), isTrue);

    await savings.renameLocation(id: locations.first.id, name: 'BCP');
    locations = await savings.loadLocations();
    expect(locations.first.name, 'BCP');

    await savings.deleteLocation(locations.first.id);
    locations = await savings.loadLocations();
    expect(locations.map((location) => location.name), ['Caja roja']);
  });

  test('no permite eliminar una ubicación con saldo', () async {
    await savings.addLocation('Caja roja');
    final location = (await savings.loadLocations()).single;
    await savings.adjustBalance(id: location.id, deltaCents: 5000);

    expect(await savings.deleteLocation(location.id), isFalse);
    expect((await savings.loadLocations()).length, 1);

    await savings.adjustBalance(id: location.id, deltaCents: -5000);
    expect(await savings.deleteLocation(location.id), isTrue);
    expect(await savings.loadLocations(), isEmpty);
  });

  test('depositar y retirar ajustan el saldo', () async {
    await savings.addLocation('Caja roja');
    final location = (await savings.loadLocations()).single;

    await savings.adjustBalance(id: location.id, deltaCents: 20000);
    await savings.adjustBalance(id: location.id, deltaCents: -5000);

    final updated = (await savings.loadLocations()).single;
    expect(updated.balanceCents, 15000);
  });

  test(
    'transferir grupo→ahorro registra un gasto en el grupo y sube el saldo',
    () async {
      final month = await openMonth();
      final casa = month.groups.first;
      await savings.addLocation('Caja roja');
      final location = (await savings.loadLocations()).single;

      await savings.transferGroupToSavings(
        monthId: month.month.id,
        groupId: casa.id,
        locationId: location.id,
        description: 'Transferencia a ahorro: Caja roja',
        amountCents: 10000,
      );

      final updatedLocation = (await savings.loadLocations()).single;
      expect(updatedLocation.balanceCents, 10000);

      final expense = (await expenses.loadExpenses(month.month.id)).single;
      expect(expense.groupId, casa.id);
      expect(expense.kind, ExpenseKind.savingsTransfer);
      expect(expense.amountCents, 10000);

      final updatedMonth = (await months.watchActiveMonth().first)!;
      expect(updatedMonth.assignedCents, month.assignedCents);
      expect(updatedMonth.generalBudgetCents, month.generalBudgetCents);
    },
  );

  test(
    'transferir grupo→grupo mueve presupuesto sin tocar el general',
    () async {
      final month = await openMonth();
      final casa = month.groups.first;
      final gasolina = month.groups.last;

      await months.transferBetweenGroups(
        sourceGroupId: casa.id,
        targetGroupId: gasolina.id,
        amountCents: 8000,
      );

      final updated = (await months.watchActiveMonth().first)!;
      expect(updated.groups.first.budgetCents, 42000);
      expect(updated.groups.last.budgetCents, 25000);
      expect(updated.assignedCents, month.assignedCents);
      expect(updated.generalBudgetCents, month.generalBudgetCents);
    },
  );
}
