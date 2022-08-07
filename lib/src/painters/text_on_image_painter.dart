import "dart:ui" as ui;
import 'package:flutter/material.dart';

class TextOnImagePainter extends CustomPainter {
  final ui.Image image;
  final ui.Rect imageRect;
  const TextOnImagePainter({
    required this.image,
    required this.imageRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    ui.Rect srcRect = ui.Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    canvas.drawImageRect(image, srcRect, imageRect, ui.Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
