import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../widgets/lock_screen_overlay.dart';
import '../../painters/gradient_painter.dart';
import '../../services/file_service.dart';
import '../../widgets/toolbar_item.dart';
import '../../widgets/editor_toolbar.dart';

const _closeTag = 'close';
const _saveTag = 'save';
const _randomGradientTag = 'random-gradient-tag';

class CreateWallpaperWithGradients extends StatefulWidget {
  const CreateWallpaperWithGradients({Key? key}) : super(key: key);

  @override
  State<CreateWallpaperWithGradients> createState() =>
      _CreateWallpaperWithGradientsState();
}

class _CreateWallpaperWithGradientsState
    extends State<CreateWallpaperWithGradients> {
  bool _isToolbarHidden = false;
  List<Color> _colors = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1), _randomGradient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _renderCanvas(),
          _renderToolbar(),
        ],
      ),
    );
  }

  EditorToolbar _renderToolbar() {
    return EditorToolbar(
      onItemPress: _onToolbarItemPress,
      isHidden: _isToolbarHidden,
      toolbarItems: const [
        ToolbarItem(
          icon: Icon(Icons.close),
          label: 'Close',
          tag: _closeTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.change_circle),
          label: 'Change',
          tag: _randomGradientTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.save_alt),
          label: 'Save',
          tag: _saveTag,
        ),
      ],
    );
  }

  CustomPaint _renderCanvas() {
    return CustomPaint(
      painter: GradientPainter(colors: _colors),
      child: _renderCanvasOverlay(),
    );
  }

  Widget _renderCanvasOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isToolbarHidden = !_isToolbarHidden;
        });
      },
      child: const LockScreenOverlay(),
    );
  }

  void _onToolbarItemPress(String tag) {
    switch (tag) {
      case _closeTag:
        Navigator.of(context).pop();
        break;
      case _saveTag:
        _onSave();
        break;
      case _randomGradientTag:
        _randomGradient();
        break;
      default:
        break;
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
    var painter = GradientPainter(colors: _colors);
    await savePainterToGallery(context, painter);
  }
}
