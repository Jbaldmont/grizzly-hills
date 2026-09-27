import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import '../../../core/money.dart';

class TrendPoint {
  const TrendPoint({
    required this.label,
    required this.amountCents,
    required this.highlighted,
  });

  final String label;
  final int amountCents;
  final bool highlighted;
}

class TagTrendChart extends StatelessWidget {
  const TagTrendChart({super.key, required this.points});

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      height: Dimens.chartHeight,
      child: BarChart(
        BarChartData(
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            for (var index = 0; index < points.length; index++)
              _buildGroup(index, colorScheme),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: colorScheme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: _buildTitles(theme),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colorScheme.inverseSurface,
              getTooltipItem: (_, groupIndex, _, _) => BarTooltipItem(
                formatBs(points[groupIndex].amountCents),
                TextStyle(color: colorScheme.onInverseSurface),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildGroup(int index, ColorScheme colorScheme) {
    final point = points[index];
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: point.amountCents / 100,
          width: Dimens.chartBarWidth,
          color: point.highlighted ? colorScheme.primary : colorScheme.outline,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimens.radiusSm),
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitles(ThemeData theme) {
    const hidden = AxisTitles();
    final axisStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return FlTitlesData(
      topTitles: hidden,
      rightTitles: hidden,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: Dimens.chartAxisReservedSize,
          maxIncluded: false,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            meta: meta,
            child: Text(formatAmount((value * 100).round()), style: axisStyle),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final point = points[value.toInt()];
            return SideTitleWidget(
              meta: meta,
              child: Text(
                point.label,
                style: axisStyle?.copyWith(
                  fontWeight: point.highlighted ? FontWeight.bold : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
