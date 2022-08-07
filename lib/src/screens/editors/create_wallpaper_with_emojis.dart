import "dart:async";
import 'package:flutter/material.dart';

import '../../widgets/lock_screen_overlay.dart';
import '../../models/emoji.dart';
import '../../painters/emoji_painter.dart';
import '../../services/file_service.dart';
import '../../widgets/toolbar_item.dart';
import '../../widgets/editor_toolbar.dart';

const _closeTag = 'close';
const _saveTag = 'save';
const _changeBackgroundTag = 'change-background';
const _changeEmojiTag = 'select-emoji';
const _changePatternTag = 'change-pattern';
const _randomizeEmojiTag = 'randomize-emoji';

enum EmojiPattern {
  random,
  grid,
}

class CreateWallpaperWithEmojis extends StatefulWidget {
  const CreateWallpaperWithEmojis({Key? key}) : super(key: key);

  @override
  State<CreateWallpaperWithEmojis> createState() =>
      _CreateWallpaperWithEmojisState();
}

class _CreateWallpaperWithEmojisState extends State<CreateWallpaperWithEmojis> {
  final String _emojiSet = '🥳😮‍💨🤑🥸🤮😘🤯🥺🤥😤😱😴';
  bool _isToolbarHidden = false;
  List<Emoji> _emojis = [];
  EmojiPattern _emojiPattern = EmojiPattern.random;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1), _populateEmojis);
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

  CustomPaint _renderCanvas() {
    return CustomPaint(
      painter: EmojiPainter(emojis: _emojis),
      isComplex: true,
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
          icon: Icon(Icons.photo),
          label: 'Background',
          tag: _changeBackgroundTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.emoji_emotions),
          label: 'Emoji',
          tag: _changeEmojiTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.change_circle),
          label: 'Pattern',
          tag: _changePatternTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.change_circle),
          label: 'Randomize',
          tag: _randomizeEmojiTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.save_alt),
          label: 'Save',
          tag: _saveTag,
        ),
      ],
    );
  }

  void _onToolbarItemPress(String tag) {
    switch (tag) {
      case _closeTag:
        Navigator.of(context).pop();
        break;
      case _changePatternTag:
        _togglePattern();
        break;
      case _randomizeEmojiTag:
        _populateEmojis();
        break;
      case _saveTag:
        _onSave();
        break;
      case _changeBackgroundTag:
        break;
      case _changeEmojiTag:
        break;
      default:
    }
  }

  void _togglePattern() {
    switch (_emojiPattern) {
      case EmojiPattern.grid:
        setState(() {
          _emojiPattern = EmojiPattern.random;
        });
        break;
      case EmojiPattern.random:
        setState(() {
          _emojiPattern = EmojiPattern.grid;
        });
        break;
      default:
        setState(() {
          _emojiPattern = EmojiPattern.random;
        });
        break;
    }
    _populateEmojis();
  }

  void _populateEmojis() {
    Size size = MediaQuery.of(context).size;
    switch (_emojiPattern) {
      case EmojiPattern.grid:
        setState(() {
          _emojis = Emoji.getGridEmojiList(size, _emojiSet);
        });
        break;
      case EmojiPattern.random:
        setState(() {
          _emojis = Emoji.getRandomEmojiList(size, _emojiSet);
        });
        break;
      default:
    }
  }

  void _onSave() async {
    double scale = MediaQuery.of(context).devicePixelRatio;
    var painter = EmojiPainter(emojis: _emojis, scale: scale);
    await savePainterToGallery(context, painter);
  }
}
