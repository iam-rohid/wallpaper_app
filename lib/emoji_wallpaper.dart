import 'dart:io';
import "dart:math";
import "dart:async";
import "dart:ui";
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/editor_toolbar.dart';
import 'package:wallpaper_app/lock_screen_overlay.dart';
import 'package:wallpaper_app/toolbar_item.dart';

class Emoji {
  final String id;
  final String emoji;
  final Offset offset;
  final double size;

  const Emoji({
    required this.id,
    required this.emoji,
    required this.offset,
    required this.size,
  });
}

class EmojiWallpapwer extends StatefulWidget {
  const EmojiWallpapwer({Key? key}) : super(key: key);

  @override
  State<EmojiWallpapwer> createState() => _EmojiWallpapwerState();
}

class _EmojiWallpapwerState extends State<EmojiWallpapwer> {
  bool _isToolbarHidden = false;
  final GlobalKey _canvasKey = GlobalKey();
  final String _emojiSet = '🥳😮‍💨🤑🥸🤮😘🤯';
  List<Emoji> _emojis = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), _generateRanomEmojis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            key: _canvasKey,
            painter: EmojiPainter(emojis: _emojis),
            isComplex: true,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isToolbarHidden = !_isToolbarHidden;
                });
              },
              child: const LockScreenOverlay(),
            ),
          ),
          EditorToolbar(
            onItemPress: _onToolbarItemPress,
            isHidden: _isToolbarHidden,
            toolbarItems: const [
              ToolbarItem(
                icon: Icon(Icons.close),
                label: 'Close',
              ),
              ToolbarItem(
                icon: Icon(Icons.photo),
                label: 'Background',
              ),
              ToolbarItem(
                icon: Icon(Icons.emoji_emotions),
                label: 'Emoji',
              ),
              ToolbarItem(
                icon: Icon(Icons.change_circle),
                label: 'Pattern',
              ),
              ToolbarItem(
                icon: Icon(Icons.change_circle),
                label: 'Randomize',
              ),
              ToolbarItem(
                icon: Icon(Icons.save_alt),
                label: 'Save',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onToolbarItemPress(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 4:
        _generateRanomEmojis();
        break;
      case 5:
        _onSave();
        break;
      default:
    }
  }

  void _generateRanomEmojis() {
    double emojiSize = 48;
    Size size = MediaQuery.of(context).size;
    int columns = (size.width / emojiSize).floor();
    int rows = (size.height / emojiSize).floor();
    double columnSize = size.width / columns;
    double rowSize = size.height / rows;
    List<Emoji> emojiArr = [];

    for (int e = 0; e < columns; e++) {
      for (int i = 0; i < rows; i++) {
        String emojiChar = _emojiSet.characters
            .elementAt(Random().nextInt(_emojiSet.characters.length));
        double dx = (e * columnSize) + ((columnSize - emojiSize) / 2);
        double dy = (i * rowSize) + ((rowSize - emojiSize) / 2);
        Offset offset = Offset(dx, dy);
        Emoji emoji = Emoji(
          id: '$e-$i',
          emoji: emojiChar,
          offset: offset,
          size: emojiSize,
        );
        emojiArr.add(emoji);
      }
    }

    setState(() {
      _emojis = emojiArr;
    });
  }

  void _onSave() async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    double scale = MediaQuery.of(context).devicePixelRatio;
    Size size = MediaQuery.of(context).size * scale;

    var painter = EmojiPainter(emojis: _emojis, scale: scale);
    painter.paint(canvas, size);

    var renderedImage = await recorder.endRecording().toImage(
          (size.width).floor(),
          (size.height).floor(),
        );
    var pngBytes = await renderedImage.toByteData(format: ImageByteFormat.png);
    Directory saveDir = await getApplicationDocumentsDirectory();
    File saveFile = File('${saveDir.path}/emoji_wallpaper.png');
    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
    }
    saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
    GallerySaver.saveImage(saveFile.path, albumName: "Wallpapers");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Saved!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}

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
            fontSize: emoji.size * scale,
            height: 1.1,
          ));
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout(minWidth: 0, maxWidth: size.width);
      tp.paint(canvas, emoji.offset * scale);
    }
  }

  void drawBackground(Canvas canvas, Size size) {
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint();
    paint.color = Colors.blue;
    canvas.drawRect(rect, paint);
  }
}
