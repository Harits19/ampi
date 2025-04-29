import 'package:ampi/line-chart/model.dart';
import 'package:flutter/material.dart';

class LineChartView<T> extends StatelessWidget {
  const LineChartView({super.key, required this.data, required this.yValue,});

  final List<T> data;

  final double Function(T value) yValue;

  @override
  Widget build(BuildContext context) {
    const marginY = 0.1;
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: CustomPaint(
        painter: LineChartPainter(
          data.asMap().entries.map((item) {
            return Offset(item.key.toDouble(), yValue(item.value) + marginY);
          }).toList(),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<Offset> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    print("data ${data.toList().toString()}");
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
    for (var point in pointData) {
      canvas.drawCircle(point, 4, paintCircle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
