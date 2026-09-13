import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/features/loans/loan_interest.dart';

void main() {
  test('la semana iniciada se cobra completa', () {
    expect(chargedWeeks(1), 1);
    expect(chargedWeeks(2), 1);
    expect(chargedWeeks(7), 1);
    expect(chargedWeeks(8), 2);
    expect(chargedWeeks(14), 2);
    expect(chargedWeeks(15), 3);
  });

  test('el interés cobra 1% por semana iniciada por defecto', () {
    expect(interestCents(principalCents: 100000, days: 2), 1000);
    expect(interestCents(principalCents: 10000, days: 7), 100);
    expect(interestCents(principalCents: 10000, days: 8), 200);
    expect(interestCents(principalCents: 10000, days: 14), 200);
  });

  test('la tasa semanal es configurable', () {
    expect(
      interestCents(principalCents: 10000, days: 3, weeklyRatePercent: 2.5),
      250,
    );
    expect(
      interestCents(principalCents: 10000, days: 10, weeklyRatePercent: 0.5),
      100,
    );
  });

  test('sin días transcurridos no hay interés', () {
    expect(interestCents(principalCents: 10000, days: 0), 0);
    expect(interestCents(principalCents: 10000, days: -5), 0);
  });

  test('los días se cuentan ignorando la hora', () {
    final from = DateTime(2026, 7, 1, 23, 59);
    final to = DateTime(2026, 7, 8, 0, 1);
    expect(interestDays(from, to), 7);
  });
}
