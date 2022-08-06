import 'dart:math';
import 'package:flutter/material.dart';

class Emoji {
  final String emoji;
  final Rect rect;

  const Emoji({
    required this.emoji,
    required this.rect,
  });

  static bool isOverlaping(Rect rect, List<Emoji> emojis) {
    for (var emoji in emojis) {
      if (rect.overlaps(emoji.rect)) {
        return true;
      }
    }
    return false;
  }

  static String getRandomEmojiFromEmojiSet(String emojiSet) {
    return emojiSet.characters.elementAt(
      Random().nextInt(emojiSet.characters.length),
    );
  }

  static Rect getRandomRect(Size size, List<Emoji> emojis) {
    double minSize = 8;
    double maxSize = 96;
    double emojiSize = min(
      maxSize,
      max(
        minSize,
        Random().nextDouble() * (maxSize + minSize),
      ),
    );
    double maxDx = size.width;
    double maxDy = size.height;
    Rect rect = Rect.zero;
    double dx = Random().nextDouble() * size.width;
    double dy = Random().nextDouble() * size.height;
    if (dx + (emojiSize / 2) > maxDx - (emojiSize / 2)) {
      rect = getRandomRect(size, emojis);
    } else if (dy + (emojiSize / 2) > maxDy - (emojiSize / 2)) {
      rect = getRandomRect(size, emojis);
    } else {
      rect = Rect.fromLTWH(dx, dy, emojiSize, emojiSize);
    }
    if (isOverlaping(rect, emojis)) {
      rect = getRandomRect(size, emojis);
    }
    return rect;
  }

  static List<Emoji> getGridEmojiList(Size size, String emojiSet) {
    List<Emoji> emojis = [];
    double emojiSize = 48;
    int columns = (size.width / emojiSize).floor();
    int rows = (size.height / emojiSize).floor();
    double columnSize = size.width / columns;
    double rowSize = size.height / rows;

    for (int e = 0; e < columns; e++) {
      for (int i = 0; i < rows; i++) {
        String emojiChar = getRandomEmojiFromEmojiSet(emojiSet);
        double dx = (e * columnSize) + ((columnSize - emojiSize) / 2);
        double dy = (i * rowSize) + ((rowSize - emojiSize) / 2);
        Rect rect = Rect.fromLTWH(dx, dy, emojiSize, emojiSize);
        Emoji emoji = Emoji(emoji: emojiChar, rect: rect);
        emojis.add(emoji);
      }
    }
    return emojis;
  }

  static List<Emoji> getRandomEmojiList(Size size, String emojiSet) {
    List<Emoji> emojis = [];
    int amount = 100;

    for (int i = 0; i < amount; i++) {
      String emojiChar = getRandomEmojiFromEmojiSet(emojiSet);
      Rect rect = getRandomRect(size, emojis);
      Emoji emoji = Emoji(emoji: emojiChar, rect: rect);
      emojis.add(emoji);
    }
    return emojis;
  }
}
