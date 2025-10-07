import 'package:flutter/material.dart';
import 'package:health_connect/app/model/chart_data_model.dart';
import 'package:health_connect/app/view/dashboard/widget/health_chart_painter.dart';
import 'package:health_connect/app/widget/app_text.dart';
import 'package:health_connect/core/style/fonts.dart';

class HealthChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final String title;
  final Color lineColor;
  final Color gradientColor;
  final String unit;
  final int maxVisiblePoints;
  final Color backgroundColor;
  final Color gridColor;
  final bool showGradient;

  const HealthChart({
    super.key,
    required this.data,
    required this.title,
    this.lineColor = const Color(0xffE64E81),
    this.gradientColor = const Color(0xffE64E81),
    this.unit = '',
    this.maxVisiblePoints = 60,
    this.backgroundColor = Colors.white,
    this.gridColor = const Color(0xFFD3D3D3),
    this.showGradient = true,
  });

  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  Offset? _tapPosition;

  late Paint _linePaint;
  late Paint _pointPaint;
  late Paint _gridPaint;
  late Paint _tooltipPaint;
  late Paint _gradientPaint;
  late TextPainter _textPainter;

  @override
  void initState() {
    super.initState();
    _initializePaints();
  }

  void _initializePaints() {
    _linePaint = Paint()
      ..color = widget.lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _pointPaint = Paint()
      ..color = widget.lineColor
      ..style = PaintingStyle.fill;

    _gridPaint = Paint()
      ..color = widget.gridColor
      ..strokeWidth = 1.0;

    _tooltipPaint = Paint()
      ..color = Colors.black.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    _gradientPaint = Paint()..style = PaintingStyle.fill;

    _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppText(
              widget.title,
              size: 18,
              family: interSemiBold,
            ),
          ),
          Expanded(
            child: GestureDetector(
              // onScaleStart: _handleScaleStart,
              // onScaleUpdate: _handleScaleUpdate,
              // onTapDown: _handleTapDown,
              onTapUp: (_) => setState(() => _tapPosition = null),
              onTapCancel: () => setState(() => _tapPosition = null),
              child: CustomPaint(
                painter: HealthChartPainter(
                  data: widget.data,
                  scale: _scale,
                  offset: _offset,
                  tapPosition: _tapPosition,
                  lineColor: widget.lineColor,
                  gradientColor: widget.gradientColor,
                  unit: widget.unit,
                  maxVisiblePoints: widget.maxVisiblePoints,
                  backgroundColor: widget.backgroundColor,
                  gridColor: widget.gridColor,
                  showGradient: widget.showGradient,
                  linePaint: _linePaint,
                  pointPaint: _pointPaint,
                  gridPaint: _gridPaint,
                  tooltipPaint: _tooltipPaint,
                  gradientPaint: _gradientPaint,
                  textPainter: _textPainter,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _handleScaleStart(ScaleStartDetails details) {
  //   _previousScale = _scale;
  //   _previousOffset = _offset;
  // }

  // void _handleScaleUpdate(ScaleUpdateDetails details) {
  //   setState(() {
  //     _scale = (_previousScale * details.scale).clamp(0.5, 5.0);
  //     _offset = _previousOffset + details.focalPointDelta;
  //   });
  // }

  // void _handleTapDown(TapDownDetails details) {
  //   setState(() {
  //     _tapPosition = details.localPosition;
  //   });
  // }
}
