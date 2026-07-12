import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/features/monthly_budget/month_repository.dart';

void main() {
  late AppDatabase db;
  late MonthRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MonthRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('siembra la plantilla con los 5 grupos reales', () async {
    final templates = await repository.loadTemplates();

    expect(templates, hasLength(5));
    expect(templates.first.name, 'Agua, Luz y Teléfonos');
    final totalCents = templates.fold(
      0,
      (sum, template) => sum + template.budgetCents,
    );
    expect(totalCents, 185000);
  });

  test('sin mes abierto, watchActiveMonth emite null', () async {
    final active = await repository.watchActiveMonth().first;

    expect(active, isNull);
  });

  test(
    'startMonth crea mes y grupos, y calcula el presupuesto general',
    () async {
      await repository.startMonth(
        date: DateTime(2026, 7, 12),
        salaryCents: 300000,
        groups: const [
          GroupDraft(name: 'Casa', budgetCents: 50000),
          GroupDraft(name: 'Leches', budgetCents: 18000),
        ],
      );

      final active = await repository.watchActiveMonth().first;

      expect(active, isNotNull);
      expect(active!.month.year, 2026);
      expect(active.month.month, 7);
      expect(active.groups.map((group) => group.name), ['Casa', 'Leches']);
      expect(active.assignedCents, 68000);
      expect(active.generalBudgetCents, 232000);
    },
  );

  test('updateMonth corrige el sueldo y los presupuestos de grupos', () async {
    await repository.startMonth(
      date: DateTime(2026, 7, 12),
      salaryCents: 300000,
      groups: const [GroupDraft(name: 'Casa', budgetCents: 50000)],
    );
    final created = (await repository.watchActiveMonth().first)!;

    await repository.updateMonth(
      monthId: created.month.id,
      salaryCents: 350000,
      groupBudgetsCents: {created.groups.single.id: 60000},
    );

    final updated = (await repository.watchActiveMonth().first)!;
    expect(updated.month.salaryCents, 350000);
    expect(updated.groups.single.budgetCents, 60000);
    expect(updated.generalBudgetCents, 290000);
  });

  test('no permite abrir dos veces el mismo mes', () async {
    await repository.startMonth(
      date: DateTime(2026, 7, 1),
      salaryCents: 100000,
      groups: const [],
    );

    expect(
      () => repository.startMonth(
        date: DateTime(2026, 7, 20),
        salaryCents: 100000,
        groups: const [],
      ),
      throwsException,
    );
  });
}
