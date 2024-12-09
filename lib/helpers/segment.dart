import 'dart:math';
import 'dart:ui';

class Segment {
  Offset start;
  Offset end;

  Segment(this.start, this.end);

  double get angle => atan2(end.dy - start.dy, end.dx - start.dx);
  Offset get midpoint => Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
  double get distance => sqrt(pow(start.dx - end.dx, 2) + pow(start.dy - end.dy, 2));

  void updateDistance(double newDistance) {
    double scale = newDistance / distance;
    double newX = start.dx + (end.dx - start.dx) * scale;
    double newY = start.dy + (end.dy - start.dy) * scale;
    end = Offset(newX, newY);
  }
}