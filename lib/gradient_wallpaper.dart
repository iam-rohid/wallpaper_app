import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/editor_toolbar.dart';
import 'package:wallpaper_app/lock_screen_overlay.dart';
import 'package:wallpaper_app/toolbar_item.dart';

class GradientWallpaper extends StatefulWidget {
  const GradientWallpaper({Key? key}) : super(key: key);

  @override
  State<GradientWallpaper> createState() => _GradientWallpaperState();
}

class _GradientWallpaperState extends State<GradientWallpaper> {
  final GlobalKey _canvasKey = GlobalKey();
  List<Color> _colors = [];
  bool _isToolbarHidden = false;

  @override
  void initState() {
    super.initState();
    _randomGradient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            key: _canvasKey,
            painter: Painter(colors: _colors),
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
                icon: Icon(Icons.change_circle),
                label: 'Change',
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
      case 1:
        _randomGradient();
        break;
      case 2:
        _onSave();
        break;
      default:
    }
  }

  void _randomGradient() {
    var colors = [
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    ];

    setState(() {
      _colors = colors;
    });
  }

  void _onSave() async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    double scale = MediaQuery.of(context).devicePixelRatio;
    var painter = Painter(colors: _colors);
    var size = (_canvasKey.currentContext?.size ?? Size.zero) * scale;
    painter.paint(canvas, size);
    var renderedImage = await recorder.endRecording().toImage(
          size.width.floor(),
          size.height.floor(),
        );

    var pngBytes = await renderedImage.toByteData(format: ImageByteFormat.png);
    Directory saveDir = await getApplicationDocumentsDirectory();
    File saveFile = File('${saveDir.path}/test2.png');
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

class Painter extends CustomPainter {
  final List<Color> colors;
  Painter({required this.colors});

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
