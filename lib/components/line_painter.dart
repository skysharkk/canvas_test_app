import 'dart:math';
import 'package:canvas_test_app/helpers/segment.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {

  final List<Offset> points;
  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < points.length - 1; i++) {
      Segment line = Segment(points[i], points[i + 1]);
      canvas.drawLine(line.start, line.end, paint);

      double angle = line.angle;
      if (angle > pi / 2 || angle < -pi / 2) {
        angle += pi;
      }

      canvas.save();
      canvas.translate(line.midpoint.dx, line.midpoint.dy);
      canvas.rotate(angle);

      textPainter.text = TextSpan(
        text: '${i + 1}) ${line.distance.toStringAsFixed(1)}',
        style: const TextStyle(color: Colors.blue, fontSize: 16),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height - 5));

      canvas.restore();
    }

    for (var point in points) {
      canvas.drawCircle(point, 6.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}