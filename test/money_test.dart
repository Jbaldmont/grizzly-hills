import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/money.dart';

void main() {
  group('parseBsToCents', () {
    test('acepta enteros y hasta dos decimales con coma o punto', () {
      expect(parseBsToCents('1850'), 185000);
      expect(parseBsToCents('18,5'), 1850);
      expect(parseBsToCents('18.50'), 1850);
      expect(parseBsToCents(' 7 '), 700);
      expect(parseBsToCents('0'), 0);
    });

    test('rechaza formatos ambiguos o inválidos', () {
      expect(parseBsToCents('1.850'), isNull);
      expect(parseBsToCents('1.234,56'), isNull);
      expect(parseBsToCents('12,345'), isNull);
      expect(parseBsToCents('1e3'), isNull);
      expect(parseBsToCents('-5'), isNull);
      expect(parseBsToCents(''), isNull);
      expect(parseBsToCents('abc'), isNull);
    });
  });

  group('formatPercent', () {
    test('los enteros no llevan decimales', () {
      expect(formatPercent(1), '1%');
      expect(formatPercent(40), '40%');
    });

    test('los decimales usan coma y sin ceros colgantes', () {
      expect(formatPercent(1.5), '1,5%');
      expect(formatPercent(1.25), '1,25%');
    });

    test('valores que redondean a entero no dejan separador colgante', () {
      expect(formatPercent(1.999), '2%');
      expect(formatPercent(0.999), '1%');
    });
  });

  group('parseWholePercent', () {
    test('solo acepta enteros', () {
      expect(parseWholePercent('1'), 1);
      expect(parseWholePercent(' 40 '), 40);
      expect(parseWholePercent('1,5'), isNull);
      expect(parseWholePercent('1.5'), isNull);
      expect(parseWholePercent(''), isNull);
    });
  });
}
