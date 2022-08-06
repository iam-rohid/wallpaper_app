import 'package:flutter/material.dart';

class GradientPainter extends CustomPainter {
  final List<Color> colors;
  GradientPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas, size);
  }

  void drawBackground(Canvas canvas, Size size) {
    var gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
