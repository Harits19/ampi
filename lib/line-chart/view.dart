import 'package:ampi/line-chart/model.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LineChartView<T> extends StatelessWidget {
  const LineChartView({
    super.key,
    required this.data,
    required this.yValue,
    required this.xString,
    required this.yString,
  });

  final List<T> data;

  final double Function(T value) yValue;
  final String Function(T value) xString;
  final String Function(T value) yString;

  @override
  Widget build(BuildContext context) {
    const marginY = 0.1;
    const heightChart = 400;
    const heightText = 24;
    const totalHeight = heightText + heightChart;
    final reverseData = data.reversed.toList();
    final width = 32 * data.length;
    if (data.isEmpty) return SizedBox();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: width.toDouble(),
        height: totalHeight.toDouble(),
        child: CustomPaint(
          painter: LineChartPainter(
            data:
                reverseData.asMap().entries.map((item) {
                  return Offset(
                    item.key.toDouble(),
                    yValue(item.value) + marginY,
                  );
                }).toList(),
            heightText: heightText,
            xValues: reverseData.map((e) => xString(e)).toList(),
            yValues: reverseData.map((e) => yString(e)).toList(),
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<Offset> data;
  final List<String> xValues, yValues;
  final num heightText;

  LineChartPainter({
    required this.data,
    required this.heightText,
    required this.xValues,
    required this.yValues,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final size = Size(canvasSize.width, canvasSize.height - heightText);
    final paintLine =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final paintCircle =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    // nilai terbesar
    final maxX = data.map((point) => point.dx).reduce((a, b) => a > b ? a : b);
    final maxY = data.map((point) => point.dy).reduce((a, b) => a > b ? a : b);

    // perbandingan ratio dengan nilai maximum
    final scaleX = size.width / maxX;
    final scaleY = size.height / maxY;

    // transform points berdasarkan ratio
    final pointData =
        data
            .map(
              (point) =>
                  Offset(point.dx * scaleX, size.height - (point.dy * scaleY)),
            )
            .toList();

    // draw the line
    for (int i = 0; i < pointData.length - 1; i++) {
      canvas.drawLine(pointData[i], pointData[i + 1], paintLine);
    }

    // draw circles on each data point
    for (var point in pointData.asMap().entries) {
      canvas.drawCircle(point.value, 4, paintCircle);
      drawXValues(
        canvas: canvas,
        text: xValues[point.key],
        x: point.value.dx,
        size: size,
      );
      drawPointValue(
        text: yValues[point.key],
        canvas: canvas,
        offset: point.value,
      );
    }
  }

  void drawPointValue({
    required String text,
    required Canvas canvas,
    required Offset offset,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: Colors.blue, fontSize: 20),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(canvas, offset);
  }

  void drawXValues({
    required Canvas canvas,
    required String text,
    required double x,
    required Size size,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: Colors.blue, fontSize: 20),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();

    // Choose where to draw the rotated text
    Offset center = Offset(x, size.height);
    double angleInRadians = -90 * 3.14159265 / 180; // -45 degrees

    // Save the current canvas state
    canvas.save();

    // Move the canvas origin to the text center
    canvas.translate(center.dx, center.dy);

    // Rotate the canvas
    canvas.rotate(angleInRadians);

    // Draw the text with offset to center it
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    // Restore the canvas to its original state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
