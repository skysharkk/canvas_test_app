import 'package:canvas_test_app/helpers/figure.dart';
import 'package:canvas_test_app/helpers/segment.dart';
import 'package:flutter/material.dart';
import 'components/length_modal.dart';
import 'components/line_painter.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingScreen> {
  List<Offset> _points = [];
  final List<double> _linesLength = [];
  bool _areLinesClosed = false;
  bool _isErrorShown = false;

  void _updateLength(List<double> value) {
    Figure figure = Figure(List<Offset>.from(_points));
    figure.setLength(value);

    if(!figure.isNumberOfPointsCorrect() && figure.isSegmentsIntersect()){
      _showErrorNotification('Невозможно преобразовать данную фигуру!');
      return;
    }

    setState(() {
      _points = figure.points;
    });
  }

  void _showErrorNotification(String text) {
    if(_isErrorShown == false) {
      _isErrorShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text,
              style: const TextStyle(fontSize: 16)),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 10,
                right: 10
            ),
          )
      ).closed.then((SnackBarClosedReason reason) { _isErrorShown = false; });
    }
  }

  void _openLengthModal() {
    if(_areLinesClosed) {
      if(_linesLength.isEmpty) {
        for (int i = 0; i < _points.length - 1; i++) {
          Segment line = Segment(_points[i], _points[i + 1]);
          _linesLength.add(line.distance);
        }
      }
      showModalBottomSheet(
        context: context,
        builder: (context) => LengthModal(linesLength: _linesLength, updateLength: _updateLength),
      );
    }
  }

  void _addPoint(Offset newPoint) {
    if(_areLinesClosed) {
      return;
    }

    List<Offset> copiedPoints = List<Offset>.from(_points);
    copiedPoints.add(newPoint);

    Figure figure = Figure(copiedPoints);

    if(figure.isSegmentsIntersect()) {
      _showErrorNotification('Линии не должны пересекаться!');
      return;
    }

    if(figure.isNumberOfPointsCorrect()) {
      Segment line = Segment(_points.first, newPoint);
      if (line.distance < 20) {
        _points.add(_points.first);
        _areLinesClosed = true;
        _openLengthModal();
        return;
      }
    }
    _points.add(newPoint);
  }

  void _clear() {
    _points.clear();
    _linesLength.clear();
    _areLinesClosed = false;
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _clear();
        });
      },
      shape: const CircleBorder(),
      backgroundColor: Colors.red,
      child: const Icon(Icons.clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canva App'),
        actions: [
          IconButton(onPressed: () {
            _openLengthModal();
          }, icon: const Icon(Icons.open_in_full))
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              setState(() {
                _addPoint(details.localPosition);
              });
            },
            child: CustomPaint(
              painter: LinePainter(_points),
              size: Size.infinite,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: buildFloatingActionButton(),
          ),
        ],
      ),
    );
  }
}

