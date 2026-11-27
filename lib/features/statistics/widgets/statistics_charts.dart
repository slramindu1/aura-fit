import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Data point for a weekly chart entry.
class WeeklyChartPoint {
  const WeeklyChartPoint({
    required this.weekLabel,
    required this.dateRange,
    required this.value,
    required this.statusLabel,
  });

  final String weekLabel;
  final String dateRange;
  final double value;
  final String statusLabel;
}

/// Interactive area line chart for Performance Index (`0..100`).
class PerformanceIndexChart extends StatelessWidget {
  const PerformanceIndexChart({
    super.key,
    required this.points,
    required this.selectedIndex,
    required this.onSelectIndex,
  });

  final List<WeeklyChartPoint> points;
  final int? selectedIndex;
  final ValueChanged<int?> onSelectIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          const leftPadding = 32.0;
          const rightPadding = 12.0;
          const topPadding = 12.0;
          const bottomPadding = 28.0;
          final chartWidth = width - leftPadding - rightPadding;
          final chartHeight = 180.0 - topPadding - bottomPadding;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final dx = (details.localPosition.dx - leftPadding).clamp(
                0.0,
                chartWidth,
              );
              final step = chartWidth / (points.length - 1);
              final index = (dx / step).round().clamp(0, points.length - 1);
              onSelectIndex(selectedIndex == index ? null : index);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, 180),
                  painter: _AreaLinePainter(
                    points: points,
                    selectedIndex: selectedIndex,
                    leftPadding: leftPadding,
                    rightPadding: rightPadding,
                    topPadding: topPadding,
                    bottomPadding: bottomPadding,
                  ),
                ),
                if (selectedIndex != null && selectedIndex! < points.length)
                  _buildTooltip(
                    point: points[selectedIndex!],
                    index: selectedIndex!,
                    leftPadding: leftPadding,
                    chartWidth: chartWidth,
                    topPadding: topPadding,
                    chartHeight: chartHeight,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTooltip({
    required WeeklyChartPoint point,
    required int index,
    required double leftPadding,
    required double chartWidth,
    required double topPadding,
    required double chartHeight,
  }) {
    final x = leftPadding + (chartWidth / (points.length - 1)) * index;
    final y = topPadding + chartHeight * (1 - (point.value / 100));
    final tooltipLeft = (x - 110).clamp(16.0, leftPadding + chartWidth - 140);

    return Positioned(
      left: tooltipLeft,
      top: (y - 6).clamp(0.0, 78.0),
      child: Container(
        width: 138,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF191920),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2E2E38)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              point.dateRange,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(color: Color(0xFF282832), height: 12),
            Text(
              '${point.value.toInt()}',
              style: const TextStyle(
                color: AppColors.primaryYellow,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              point.statusLabel,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive bar chart for Training Volume (`0..7`).
class TrainingVolumeChart extends StatelessWidget {
  const TrainingVolumeChart({
    super.key,
    required this.points,
    required this.selectedIndex,
    required this.onSelectIndex,
  });

  final List<WeeklyChartPoint> points;
  final int? selectedIndex;
  final ValueChanged<int?> onSelectIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          const leftPadding = 26.0;
          const rightPadding = 8.0;
          const topPadding = 10.0;
          const bottomPadding = 28.0;
          final chartWidth = width - leftPadding - rightPadding;
          final slotWidth = chartWidth / points.length;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final dx = (details.localPosition.dx - leftPadding).clamp(
                0.0,
                chartWidth - 1,
              );
              final index = (dx / slotWidth).floor().clamp(
                0,
                points.length - 1,
              );
              onSelectIndex(selectedIndex == index ? null : index);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, 196),
                  painter: _BarChartPainter(
                    points: points,
                    selectedIndex: selectedIndex,
                    leftPadding: leftPadding,
                    rightPadding: rightPadding,
                    topPadding: topPadding,
                    bottomPadding: bottomPadding,
                  ),
                ),
                if (selectedIndex != null && selectedIndex! < points.length)
                  Positioned(
                    left: (leftPadding + slotWidth * selectedIndex! - 90)
                        .clamp(16.0, width - 150),
                    top: 14,
                    child: Container(
                      width: 142,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191920),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2E2E38)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            points[selectedIndex!].dateRange,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(color: Color(0xFF282832), height: 12),
                          Text(
                            'Total Workout',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${points[selectedIndex!].value.toInt()}',
                            style: const TextStyle(
                              color: AppColors.primaryYellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AreaLinePainter extends CustomPainter {
  const _AreaLinePainter({
    required this.points,
    required this.selectedIndex,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
  });

  final List<WeeklyChartPoint> points;
  final int? selectedIndex;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final gridPaint = Paint()
      ..color = const Color(0xFF2A2A34)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    for (final level in [0, 50, 100]) {
      final y = topPadding + chartHeight * (1 - level / 100);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
      textPainter.text = TextSpan(
        text: '$level',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    if (points.isEmpty) return;

    final stepX = points.length > 1 ? chartWidth / (points.length - 1) : 0.0;
    final linePath = Path();
    final fillPath = Path();

    final coords = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = leftPadding + stepX * i;
      final y = topPadding + chartHeight * (1 - points[i].value / 100);
      coords.add(Offset(x, y));

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, topPadding + chartHeight);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      textPainter.text = TextSpan(
        text: points[i].weekLabel,
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.72),
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, topPadding + chartHeight + 10),
      );
    }

    fillPath.lineTo(coords.last.dx, topPadding + chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, topPadding),
        Offset(0, topPadding + chartHeight),
        [
          AppColors.primaryYellow.withValues(alpha: 0.35),
          AppColors.primaryYellow.withValues(alpha: 0.0),
        ],
      );
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primaryYellow
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);

    if (selectedIndex != null && selectedIndex! < coords.length) {
      final pt = coords[selectedIndex!];
      canvas.drawCircle(
        pt,
        5,
        Paint()..color = AppColors.primaryYellow,
      );
      canvas.drawCircle(
        pt,
        2.5,
        Paint()..color = AppColors.textDark,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AreaLinePainter oldDelegate) => true;
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.points,
    required this.selectedIndex,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
  });

  final List<WeeklyChartPoint> points;
  final int? selectedIndex;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final gridPaint = Paint()
      ..color = const Color(0xFF2A2A34)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    for (var i = 0; i <= 7; i++) {
      final y = topPadding + chartHeight * (1 - i / 7);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    final slotWidth = chartWidth / points.length;
    final barWidth = slotWidth * 0.68;

    for (var i = 0; i < points.length; i++) {
      final centerX = leftPadding + slotWidth * (i + 0.5);
      final barHeight = chartHeight * (points[i].value / 7).clamp(0.0, 1.0);
      final topY = topPadding + chartHeight - barHeight;
      final rect = Rect.fromLTWH(
        centerX - barWidth / 2,
        topY,
        barWidth,
        barHeight,
      );

      final isSelected = selectedIndex == i;
      final barPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, topY),
          Offset(0, topPadding + chartHeight),
          [
            AppColors.primaryYellow.withValues(alpha: isSelected ? 0.42 : 0.25),
            AppColors.primaryYellow.withValues(alpha: 0.02),
          ],
        );
      canvas.drawRect(rect, barPaint);

      canvas.drawLine(
        Offset(rect.left, topY),
        Offset(rect.right, topY),
        Paint()
          ..color = AppColors.primaryYellow
          ..strokeWidth = 2.2,
      );

      textPainter.text = TextSpan(
        text: points[i].weekLabel,
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.72),
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, topPadding + chartHeight + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) => true;
}
