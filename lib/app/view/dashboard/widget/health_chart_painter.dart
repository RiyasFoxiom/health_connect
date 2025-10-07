import 'package:flutter/material.dart';
import 'package:health_connect/app/model/chart_data_model.dart';

class HealthChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final double scale;
  final Offset offset;
  final Offset? tapPosition;
  final Color lineColor;
  final Color gradientColor;
  final String unit;
  final int maxVisiblePoints;
  final Color backgroundColor;
  final Color gridColor;
  final bool showGradient;

  final Paint linePaint;
  final Paint pointPaint;
  final Paint gridPaint;
  final Paint tooltipPaint;
  final Paint gradientPaint;
  final TextPainter textPainter;

  List<Offset>? _cachedPoints;
  double? _cachedMinValue;
  double? _cachedMaxValue;
  DateTime? _cachedMinTimestamp;
  DateTime? _cachedMaxTimestamp;

  HealthChartPainter({
    required this.data,
    required this.scale,
    required this.offset,
    this.tapPosition,
    required this.lineColor,
    required this.gradientColor,
    required this.unit,
    required this.maxVisiblePoints,
    required this.backgroundColor,
    required this.gridColor,
    required this.showGradient,
    required this.linePaint,
    required this.pointPaint,
    required this.gridPaint,
    required this.tooltipPaint,
    required this.gradientPaint,
    required this.textPainter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      _drawEmptyState(canvas, size);
      return;
    }

    final displayData = _decimateData(data, maxVisiblePoints);
    final bounds = _calculateBounds(displayData);
    _cachedMinValue = bounds['minValue']!;
    _cachedMaxValue = bounds['maxValue']!;
    _cachedMinTimestamp = bounds['minTimestamp']!;
    _cachedMaxTimestamp = bounds['maxTimestamp']!;

    final points = _transformPoints(displayData, size);
    _cachedPoints = points;

    _drawGrid(canvas, size);

    if (showGradient) {
      _drawGradientFill(canvas, size, points);
    }

    _drawLine(canvas, points);
    _drawAxesLabels(canvas, size, displayData);

    if (tapPosition != null && points.isNotEmpty) {
      _drawTooltip(canvas, size, points, displayData);
    }
  }

  List<ChartDataPoint> _decimateData(List<ChartDataPoint> data, int maxPoints) {
    if (data.length <= maxPoints) return data;

    final step = data.length / maxPoints;
    final decimated = <ChartDataPoint>[];

    for (int i = 0; i < maxPoints; i++) {
      final index = (i * step).floor();
      if (index < data.length) {
        decimated.add(data[index]);
      }
    }

    return decimated;
  }

  Map<String, dynamic> _calculateBounds(List<ChartDataPoint> data) {
    double minValue = data.first.value;
    double maxValue = data.first.value;
    DateTime minTimestamp = data.first.timestamp;
    DateTime maxTimestamp = data.first.timestamp;

    for (final point in data) {
      if (point.value < minValue) minValue = point.value;
      if (point.value > maxValue) maxValue = point.value;
      if (point.timestamp.isBefore(minTimestamp)) {
        minTimestamp = point.timestamp;
      }
      if (point.timestamp.isAfter(maxTimestamp)) maxTimestamp = point.timestamp;
    }

    final valuePadding = (maxValue - minValue) * 0.15;
    return {
      'minValue': minValue - valuePadding,
      'maxValue': maxValue + valuePadding,
      'minTimestamp': minTimestamp,
      'maxTimestamp': maxTimestamp,
    };
  }

  List<Offset> _transformPoints(List<ChartDataPoint> data, Size size) {
    final points = <Offset>[];
    final padding = EdgeInsets.only(left: 50, right: 20, top: 20, bottom: 40);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    final minValue = _cachedMinValue!;
    final maxValue = _cachedMaxValue!;
    final valueRange = maxValue - minValue;

    final minTimestamp = _cachedMinTimestamp!.millisecondsSinceEpoch.toDouble();
    final maxTimestamp = _cachedMaxTimestamp!.millisecondsSinceEpoch.toDouble();
    final timeRange = maxTimestamp - minTimestamp;

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final normalizedTime =
          (point.timestamp.millisecondsSinceEpoch - minTimestamp) / timeRange;
      final x = padding.left + normalizedTime * chartWidth;
      final normalizedValue = (point.value - minValue) / valueRange;
      final y = padding.top + chartHeight - (normalizedValue * chartHeight);

      final transformedX =
          (x - size.width / 2) * scale + size.width / 2 + offset.dx;
      final transformedY =
          (y - size.height / 2) * scale + size.height / 2 + offset.dy;

      points.add(Offset(transformedX, transformedY));
    }

    return points;
  }

  void _drawGrid(Canvas canvas, Size size) {
    final padding = EdgeInsets.only(left: 50, right: 20, top: 20, bottom: 40);

    // Horizontal grid lines (Y-axis, 5 lines)
    for (int i = 0; i <= 5; i++) {
      final y =
          padding.top + ((size.height - padding.top - padding.bottom) / 5) * i;
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
    }

    // Vertical grid lines (X-axis, 6 lines)
    for (int i = 0; i <= 6; i++) {
      final x =
          padding.left + ((size.width - padding.left - padding.right) / 6) * i;
      canvas.drawLine(
        Offset(x, padding.top),
        Offset(x, size.height - padding.bottom),
        gridPaint,
      );
    }
  }

  void _drawGradientFill(Canvas canvas, Size size, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, size.height - 40);
    path.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    path.lineTo(points.last.dx, size.height - 40);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        gradientColor.withValues(alpha: 0.9),
        gradientColor.withValues(alpha: 0.08),
        gradientColor.withValues(alpha: 0.0),
      ],
      stops: [0.0, 0.6, 1.0],
    );

    gradientPaint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    canvas.drawPath(path, gradientPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawAxesLabels(Canvas canvas, Size size, List<ChartDataPoint> data) {
    if (data.isEmpty) return;

    final padding = EdgeInsets.only(left: 50, right: 20, top: 20, bottom: 40);

    // Y-axis labels (dynamic values)
    for (int i = 0; i <= 5; i++) {
      final value =
          _cachedMaxValue! - ((_cachedMaxValue! - _cachedMinValue!) / 5) * i;
      final y =
          padding.top + ((size.height - padding.top - padding.bottom) / 5) * i;

      String formattedValue;
      if (value >= 1000) {
        formattedValue = '${(value / 1000).toStringAsFixed(0)}K';
      } else {
        formattedValue = value.toStringAsFixed(0);
      }

      textPainter.text = TextSpan(
        text: formattedValue,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    // X-axis labels (HH:MM timestamps for both charts)
    final labelCount = 6;
    final minTimestamp = _cachedMinTimestamp!;
    final maxTimestamp = _cachedMaxTimestamp!;
    final timeRangeMs =
        maxTimestamp.millisecondsSinceEpoch -
        minTimestamp.millisecondsSinceEpoch;

    for (int i = 0; i < labelCount; i++) {
      final normalizedTime = i / (labelCount - 1);
      final timestampMs =
          minTimestamp.millisecondsSinceEpoch + normalizedTime * timeRangeMs;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        timestampMs.toInt(),
      );
      final x =
          padding.left +
          ((size.width - padding.left - padding.right) / (labelCount - 1)) * i;

      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final timeStr = '$hour:$minute';

      textPainter.text = TextSpan(
        text: timeStr,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 30),
      );
    }
  }

  void _drawTooltip(
    Canvas canvas,
    Size size,
    List<Offset> points,
    List<ChartDataPoint> data,
  ) {
    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < points.length; i++) {
      final distance = (points[i] - tapPosition!).distance;
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    if (nearestIndex >= data.length) return;

    final nearestPoint = points[nearestIndex];
    final dataPoint = data[nearestIndex];

    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(nearestPoint, 12, glowPaint);
    canvas.drawCircle(nearestPoint, 8, glowPaint);

    canvas.drawCircle(
      nearestPoint,
      6,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawCircle(nearestPoint, 4, Paint()..color = backgroundColor);

    canvas.drawCircle(nearestPoint, 2, Paint()..color = lineColor);

    final linePaint = Paint()
      ..color = lineColor.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(nearestPoint.dx, 20),
      Offset(nearestPoint.dx, size.height - 40),
      linePaint,
    );

    final timestamp = dataPoint.timestamp;
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';
    final valueStr = '${dataPoint.value.toStringAsFixed(0)} $unit';

    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: '$valueStr\n',
          style: TextStyle(
            color: lineColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: timeStr,
          style: TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
    textPainter.textAlign = TextAlign.center;
    textPainter.layout();

    final tooltipWidth = textPainter.width + 24;
    final tooltipHeight = textPainter.height + 20;
    var tooltipX = nearestPoint.dx - tooltipWidth / 2;
    var tooltipY = nearestPoint.dy - tooltipHeight - 15;

    if (tooltipX < 10) tooltipX = 10;
    if (tooltipX + tooltipWidth > size.width - 10) {
      tooltipX = size.width - tooltipWidth - 10;
    }
    if (tooltipY < 10) tooltipY = nearestPoint.dy + 15;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
      Radius.circular(8),
    );

    canvas.drawRRect(rect, tooltipPaint);
    textPainter.paint(canvas, Offset(tooltipX + 12, tooltipY + 10));
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    textPainter.text = TextSpan(
      text: 'No data available',
      style: TextStyle(color: Colors.black54, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(HealthChartPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.tapPosition != tapPosition ||
        oldDelegate.data != data ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gradientColor != gradientColor;
  }
}
