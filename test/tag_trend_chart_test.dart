import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/dimens.dart';
import 'package:grizzly_hills/features/tags/widgets/tag_trend_chart.dart';

const _bottomTitlesReservedSize = 22.0;

void main() {
  final darkTheme = ThemeData(brightness: Brightness.dark);

  Future<void> pumpChart(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: darkTheme,
        home: Scaffold(
          body: ListView(
            children: const [
              SizedBox(height: 300),
              TagTrendChart(
                points: [
                  TrendPoint(label: 'Sep', amountCents: 9000, highlighted: true),
                ],
              ),
              SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Offset barCenter(WidgetTester tester) {
    final rect = tester.getRect(find.byType(BarChart));
    final plotLeft = rect.left + Dimens.chartAxisReservedSize;
    final plotBottom = rect.bottom - _bottomTitlesReservedSize;
    return Offset((plotLeft + rect.right) / 2, (rect.top + plotBottom) / 2);
  }

  List<int> shownTooltips(WidgetTester tester) => tester
      .widget<BarChart>(find.byType(BarChart))
      .data
      .barGroups
      .single
      .showingTooltipIndicators;

  testWidgets('no usa los toques automáticos de fl_chart', (tester) async {
    await pumpChart(tester);

    final chart = tester.widget<BarChart>(find.byType(BarChart));
    expect(chart.data.barTouchData.handleBuiltInTouches, isFalse);
  });

  testWidgets('tocar sin soltar no muestra el globo', (tester) async {
    await pumpChart(tester);

    final gesture = await tester.startGesture(barCenter(tester));
    await tester.pump(const Duration(milliseconds: 100));
    expect(shownTooltips(tester), isEmpty);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('deslizar desde la barra no muestra el globo', (tester) async {
    await pumpChart(tester);

    final gesture = await tester.startGesture(barCenter(tester));
    for (var step = 0; step < 5; step++) {
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump(const Duration(milliseconds: 16));
      expect(shownTooltips(tester), isEmpty);
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(shownTooltips(tester), isEmpty);
  });

  testWidgets('un toque fija el globo y otro toque lo oculta', (tester) async {
    await pumpChart(tester);

    await tester.tapAt(barCenter(tester));
    await tester.pumpAndSettle();
    expect(shownTooltips(tester), [0]);

    await tester.tapAt(barCenter(tester));
    await tester.pumpAndSettle();
    expect(shownTooltips(tester), isEmpty);
  });

  testWidgets('el globo usa un color del tema, no blanco', (tester) async {
    await pumpChart(tester);

    final chart = tester.widget<BarChart>(find.byType(BarChart));
    final group = chart.data.barGroups.single;
    final tooltipColor = chart.data.barTouchData.touchTooltipData
        .getTooltipColor(group);

    expect(tooltipColor, darkTheme.colorScheme.surfaceContainerHighest);
  });
}
