import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import '../../../core/money.dart';

@immutable
class TrendPoint {
  const TrendPoint({
    required this.label,
    required this.amountCents,
    required this.highlighted,
  });

  final String label;
  final int amountCents;
  final bool highlighted;

  @override
  bool operator ==(Object other) =>
      other is TrendPoint &&
      other.label == label &&
      other.amountCents == amountCents &&
      other.highlighted == highlighted;

  @override
  int get hashCode => Object.hash(label, amountCents, highlighted);
}

class TagTrendChart extends StatefulWidget {
  const TagTrendChart({super.key, required this.points});

  final List<TrendPoint> points;

  @override
  State<TagTrendChart> createState() => _TagTrendChartState();
}

class _TagTrendChartState extends State<TagTrendChart> {
  int? _selectedIndex;

  @override
  void didUpdateWidget(TagTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.points, widget.points)) {
      _selectedIndex = null;
    }
  }

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
            for (var index = 0; index < widget.points.length; index++)
              _buildGroup(index, colorScheme),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: colorScheme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: _buildTitles(theme),
          barTouchData: _buildTouchData(colorScheme),
        ),
      ),
    );
  }

  BarTouchData _buildTouchData(ColorScheme colorScheme) {
    return BarTouchData(
      handleBuiltInTouches: false,
      touchCallback: _handleTouch,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
        tooltipBorder: BorderSide(color: colorScheme.outlineVariant),
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItem: (_, groupIndex, _, _) => BarTooltipItem(
          formatBs(widget.points[groupIndex].amountCents),
          TextStyle(color: colorScheme.onSurface),
        ),
      ),
    );
  }

  void _handleTouch(FlTouchEvent event, BarTouchResponse? response) {
    if (event is! FlTapUpEvent) {
      return;
    }
    final touchedIndex = response?.spot?.touchedBarGroupIndex;
    setState(() {
      _selectedIndex = touchedIndex == _selectedIndex ? null : touchedIndex;
    });
  }

  BarChartGroupData _buildGroup(int index, ColorScheme colorScheme) {
    final point = widget.points[index];
    return BarChartGroupData(
      x: index,
      showingTooltipIndicators: index == _selectedIndex ? const [0] : const [],
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
            final point = widget.points[value.toInt()];
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
