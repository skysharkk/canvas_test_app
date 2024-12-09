import 'package:canvas_test_app/drawing_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingScreen(),
    );
  }
}


