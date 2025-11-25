import 'package:flutter/rendering.dart';

class CircleProgressPainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color emptyColor;

  CircleProgressPainter({required this.percent, required this.color, required this.emptyColor});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.08;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = emptyColor
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweep = 2 * 3.141592653589793 * percent;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final start = -3.141592653589793 / 2;

    if (percent > 0) {
      canvas.drawArc(rect, start, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircleProgressPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color || oldDelegate.emptyColor != emptyColor;
  }
}