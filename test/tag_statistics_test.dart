import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/features/tags/tag_statistics.dart';

const _september = 2;
const _august = 1;
const _comida = 10;
const _bebidas = 11;

final _statistics = TagStatistics(const [
  SpendingEntry(
    monthId: _september,
    amountCents: 3000,
    groupName: 'Gastos Míos',
    tagId: _comida,
  ),
  SpendingEntry(
    monthId: _september,
    amountCents: 1500,
    groupName: 'Gastos Míos',
    tagId: _bebidas,
  ),
  SpendingEntry(
    monthId: _september,
    amountCents: 5000,
    groupName: 'Casa',
    tagId: _comida,
  ),
  SpendingEntry(monthId: _september, amountCents: 2000, groupName: 'Casa'),
  SpendingEntry(monthId: _september, amountCents: 700, tagId: _bebidas),
  SpendingEntry(
    monthId: _august,
    amountCents: 4000,
    groupName: 'Gastos Míos',
    tagId: _comida,
  ),
]);

void main() {
  test('desglose del mes ordenado de mayor a menor', () {
    final breakdown = _statistics.tagBreakdown(
      _september,
      const SpendingScope.all(),
    );

    expect(breakdown.map((item) => item.tagId), [_comida, _bebidas]);
    expect(breakdown.map((item) => item.amountCents), [8000, 2200]);
  });

  test('el total incluye lo que no tiene etiqueta', () {
    const scope = SpendingScope.all();

    expect(_statistics.totalCents(_september, scope), 12200);
    expect(_statistics.untaggedCents(_september, scope), 2000);
  });

  test('filtra por grupo', () {
    const scope = SpendingScope.group('Gastos Míos');
    final breakdown = _statistics.tagBreakdown(_september, scope);

    expect(breakdown.map((item) => item.amountCents), [3000, 1500]);
    expect(_statistics.untaggedCents(_september, scope), 0);
    expect(_statistics.totalCents(_september, scope), 4500);
  });

  test('filtra solo imprevistos', () {
    const scope = SpendingScope.unexpected();

    expect(_statistics.totalCents(_september, scope), 700);
    expect(_statistics.tagCents(_september, _bebidas, scope), 700);
  });

  test('suma una etiqueta por mes respetando el filtro', () {
    const scope = SpendingScope.group('Gastos Míos');

    expect(_statistics.tagCents(_august, _comida, scope), 4000);
    expect(_statistics.tagCents(_september, _comida, scope), 3000);
    expect(
      _statistics.tagCents(_september, _comida, const SpendingScope.all()),
      8000,
    );
  });

  test('lista los grupos sin repetir y sin imprevistos', () {
    expect(_statistics.groupNames, ['Gastos Míos', 'Casa']);
  });

  test('un mes sin gastos no tiene desglose', () {
    const emptyMonth = 99;

    expect(
      _statistics.tagBreakdown(emptyMonth, const SpendingScope.all()),
      isEmpty,
    );
    expect(_statistics.totalCents(emptyMonth, const SpendingScope.all()), 0);
  });

  test('dos filtros iguales son equivalentes', () {
    expect(
      const SpendingScope.group('Casa'),
      SpendingScope.group(['Ca', 'sa'].join()),
    );
    expect(
      const SpendingScope.all() == const SpendingScope.unexpected(),
      isFalse,
    );
  });
}
