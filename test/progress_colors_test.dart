import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/theme/progress_colors.dart';

void main() {
  test('los umbrales 50/75/90 asignan los cuatro colores', () {
    expect(ProgressColors.forRatio(0.0), ProgressColors.low);
    expect(ProgressColors.forRatio(0.49), ProgressColors.low);
    expect(ProgressColors.forRatio(0.5), ProgressColors.medium);
    expect(ProgressColors.forRatio(0.74), ProgressColors.medium);
    expect(ProgressColors.forRatio(0.75), ProgressColors.high);
    expect(ProgressColors.forRatio(0.89), ProgressColors.high);
    expect(ProgressColors.forRatio(0.9), ProgressColors.critical);
    expect(ProgressColors.forRatio(1.5), ProgressColors.critical);
  });
}
