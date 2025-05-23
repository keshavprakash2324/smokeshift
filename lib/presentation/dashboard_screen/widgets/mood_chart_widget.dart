import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> moodData;

  const MoodChartWidget({
    super.key,
    required this.moodData,
  });

  @override
  State<MoodChartWidget> createState() => _MoodChartWidgetState();
}

class _MoodChartWidgetState extends State<MoodChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your mood is improving',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.moodRelaxed.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.moodRelaxed,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '+12%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.moodRelaxed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Semantics(
              label: "Mood improvement line chart over time",
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    final List<FlSpot> spots = widget.moodData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['value']);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppTheme.lightTheme.colorScheme.outline.withAlpha(51),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: widget.moodData.length.toDouble() - 1,
      minY: 0,
      maxY: 5,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.x.toInt();
              if (index >= 0 && index < widget.moodData.length) {
                final date = widget.moodData[index]['date'];
                return LineTooltipItem(
                  '$date: ${barSpot.y.toStringAsFixed(1)}',
                  AppTheme.lightTheme.textTheme.labelMedium!,
                );
              }
              return null;
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (event is FlPanEndEvent || event is FlTapUpEvent || touchResponse == null || touchResponse.lineBarSpots == null) {
              touchedIndex = -1;
            } else {
              touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            }
          });
        },
        handleBuiltInTouches: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              AppTheme.moodRelaxed.withAlpha(204),
              AppTheme.moodRelaxed,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.moodRelaxed,
                strokeWidth: 2,
                strokeColor: AppTheme.lightTheme.colorScheme.surface,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.moodRelaxed.withAlpha(77),
                AppTheme.moodRelaxed.withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int index = value.toInt();
    if (index < 0 || index >= widget.moodData.length) {
      return const SizedBox.shrink();
    }
    
    final style = AppTheme.lightTheme.textTheme.labelSmall;
    final text = widget.moodData[index]['date'] as String;
    
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Low';
        break;
      case 3:
        text = 'Mid';
        break;
      case 5:
        text = 'High';
        break;
      default:
        return const SizedBox.shrink();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.labelSmall,
        textAlign: TextAlign.left,
      ),
    );
  }
}