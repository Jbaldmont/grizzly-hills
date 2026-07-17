import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/features/loans/loan_interest.dart';

void main() {
  test('el interés es 1% semanal prorrateado por días', () {
    expect(interestCents(principalCents: 10000, days: 7), 100);
    expect(interestCents(principalCents: 10000, days: 14), 200);
    expect(interestCents(principalCents: 10000, days: 1), 14);
    expect(interestCents(principalCents: 10000, days: 3), 43);
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
