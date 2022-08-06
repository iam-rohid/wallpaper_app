import 'package:flutter/material.dart';
import '../models/emoji.dart';

class EmojiPainter extends CustomPainter {
  final List<Emoji> emojis;
  final double scale;
  EmojiPainter({required this.emojis, this.scale = 1});

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas, size);
    drawEmojis(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawEmojis(Canvas canvas, Size size) {
    for (var emoji in emojis) {
      var span = TextSpan(
          text: emoji.emoji,
          style: TextStyle(
            fontSize: emoji.rect.width * scale,
            height: 1.1,
          ));
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout(minWidth: 0, maxWidth: size.width);
      tp.paint(canvas, emoji.rect.topLeft * scale);
    }
  }

  void drawBackground(Canvas canvas, Size size) {
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint();
    paint.color = Colors.blue;
    canvas.drawRect(rect, paint);
  }
}
