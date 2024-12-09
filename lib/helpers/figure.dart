import 'dart:math';
import 'dart:ui';

class Figure {
  List<Offset> points;
  Figure(this.points);
  static const int _minPointsLength = 4;

  bool _onSegment(Offset checkedPoint, Offset segmentStart, Offset segmentEnd){
    return checkedPoint.dx <= max(segmentStart.dx, segmentEnd.dx) && checkedPoint.dx >= min(segmentStart.dx, segmentEnd.dx) &&
        checkedPoint.dy <= max(segmentStart.dy, segmentEnd.dy) && checkedPoint.dy >= min(segmentStart.dy, segmentEnd.dy);
  }

  int _getDirections(Offset firstPoint, Offset secondPoint, Offset thirdPoint ){
    double val = (secondPoint.dy - firstPoint.dy) * (thirdPoint.dx - secondPoint.dx) - (secondPoint.dx - firstPoint.dx) * (thirdPoint.dy - secondPoint.dy);
    if (val == 0) return 0;
    return val > 0 ? 1 : -1; // 1 - по часовой, -1 - против часовой
  }

  bool _isSegmentIntersect(Offset segmentStart1, Offset segmentEnd1, Offset segmentStart2, Offset segmentEnd2){
    int dir1 = _getDirections(segmentStart1, segmentEnd1, segmentStart2);
    int dir2 = _getDirections(segmentStart1, segmentEnd1, segmentEnd2);
    int dir3 = _getDirections(segmentStart2, segmentEnd2, segmentStart1);
    int dir4 = _getDirections(segmentStart2, segmentEnd2, segmentEnd1);

    if (dir1 != dir2 && dir3 != dir4) return true;
    if (dir1 == 0 && _onSegment(segmentStart2, segmentStart1, segmentEnd1)) return true;
    if (dir2 == 0 && _onSegment(segmentEnd2, segmentStart1,  segmentEnd1)) return true;
    if (dir3 == 0 && _onSegment(segmentStart1,segmentStart2, segmentEnd2)) return true;
    if (dir4 == 0 && _onSegment(segmentEnd1, segmentStart2,  segmentEnd2)) return true;

    return false;
  }

  void _correctAngles() {
    List<Offset> correctedVertices = [points.first];
    for (int i = 1; i < points.length - 1; i++) {
      Offset prev = correctedVertices[correctedVertices.length - 1];
      Offset current = points[i];
      Offset vector1 = Offset(current.dx - prev.dx, current.dy - prev.dy);
      if (vector1.dx.abs() > vector1.dy.abs()) {
        correctedVertices.add(Offset(current.dx, prev.dy));
      } else {
        correctedVertices.add(Offset(prev.dx, current.dy));
      }
    }
    Offset lastCorrected = correctedVertices.last;
    Offset first = correctedVertices.first;
    Offset secondLast = correctedVertices[correctedVertices.length - 2];
    if ((lastCorrected.dx - secondLast.dx).abs() > (lastCorrected.dy - secondLast.dy).abs()) {
      correctedVertices[correctedVertices.length - 1] = Offset(first.dx, lastCorrected.dy);
    } else {
      correctedVertices[correctedVertices.length - 1] = Offset(lastCorrected.dx, first.dy);
    }
    correctedVertices.add(correctedVertices.first);
    points = correctedVertices;
  }

  void setLength(List<double> lineLengths) {
    _correctAngles();
    List<Offset> adjustedVertices = [points[0]];

    for (int i = 0; i < lineLengths.length; i++) {
      Offset current = adjustedVertices[i];
      Offset next = points[(i + 1) % lineLengths.length];

      double dx = next.dx - points[i].dx;
      double dy = next.dy - points[i].dy;

      if (dx != 0) {
        double direction = dx.sign;
        adjustedVertices.add(
            Offset(
                current.dx + direction * lineLengths[i],
                current.dy
            )
        );
      } else if (dy != 0) {
        double direction = dy.sign;
        adjustedVertices.add(
            Offset(
              current.dx,
              current.dy + direction * lineLengths[i],
            )
        );
      }
    }
    points = adjustedVertices;
  }

  bool isSegmentsIntersect() {
    int n = points.length;
    // bool isClosed = points[0].dx == points[n - 1].dx && points[0].dy == points[n - 1].dy;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j <  n; j++) {
        if ((i - j).abs() <= 1 || (i == 0 && j == n - 1)) continue;

        Offset segmentStart1 = points[i];
        Offset segmentEnd1 = points[(i + 1) % n];
        Offset segmentStart2 = points[j];
        Offset segmentEnd2 = points[(j + 1) % n];

        if (_isSegmentIntersect(segmentStart1, segmentEnd1, segmentStart2, segmentEnd2)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isNumberOfPointsCorrect() {
    return points.length > _minPointsLength;
  }
}