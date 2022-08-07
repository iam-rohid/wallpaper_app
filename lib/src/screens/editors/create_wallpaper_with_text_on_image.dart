import 'dart:async';
import 'dart:io';
import "dart:ui" as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../painters/text_on_image_painter.dart';
import '../../services/file_service.dart';
import '../../widgets/editor_toolbar.dart';
import '../../widgets/lock_screen_overlay.dart';
import '../../widgets/toolbar_item.dart';

const _closeTag = 'close';
const _saveTag = 'save';
const _changeBackgroundTag = 'change-background';
const _addTextTag = 'add-text';

class CreateWallpaperWithTextOnImage extends StatefulWidget {
  const CreateWallpaperWithTextOnImage({Key? key}) : super(key: key);

  @override
  State<CreateWallpaperWithTextOnImage> createState() =>
      _CreateWallpaperWithTextOnImageState();
}

class _CreateWallpaperWithTextOnImageState
    extends State<CreateWallpaperWithTextOnImage> {
  bool _isToolbarHidden = false;
  bool _isLoadingImage = false;
  late final ImagePicker _picker;
  ui.Image? _image;
  ui.Rect _imageRect = ui.Rect.zero;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    Timer(const Duration(milliseconds: 1), () => _selectBackgroundImage());
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
          icon: Icon(Icons.add_a_photo),
          label: 'Background',
          tag: _changeBackgroundTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.text_fields),
          label: 'Add Text',
          tag: _addTextTag,
        ),
        ToolbarItem(
          icon: Icon(Icons.save_alt),
          label: 'Save',
          tag: _saveTag,
        ),
      ],
    );
  }

  Widget _renderCanvas() {
    if (_image == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add Background Color"),
            if (_isLoadingImage) Text("Loading image")
          ],
        ),
      );
    }
    return CustomPaint(
      painter: TextOnImagePainter(
        image: _image!,
        imageRect: _imageRect,
      ),
      child: _renderCanvasOverlay(),
    );
  }

  Widget _renderCanvasOverlay() {
    return GestureDetector(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isToolbarHidden = !_isToolbarHidden;
          });
        },
        onScaleUpdate: (details) {
          double dx = details.focalPointDelta.dx + _imageRect.left;
          double dy = details.focalPointDelta.dy + _imageRect.top;
          double width = _imageRect.width;
          double height = _imageRect.height;
          _imageRect = ui.Rect.fromLTWH(
            dx,
            dy,
            width,
            height,
          );
          _imageRect = _imageRect.inflate(details.scale);
          setState(() {});
        },
        child: const LockScreenOverlay(),
      ),
    );
  }

  void _onToolbarItemPress(String tag) {
    if (_isLoadingImage) return;
    switch (tag) {
      case _closeTag:
        Navigator.of(context).pop();
        break;
      case _saveTag:
        _onSave();
        break;
      case _changeBackgroundTag:
        _selectBackgroundImage();
        break;
      case _addTextTag:
        _onAddText();
        break;
      default:
        break;
    }
  }

  void _selectBackgroundImage() async {
    if (_isLoadingImage) return;
    setState(() {
      _isLoadingImage = true;
    });
    try {
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        setState(() {
          _isLoadingImage = false;
        });
        return;
      }
      final file = await File(xFile.path).readAsBytes();
      ui.decodeImageFromList(file, (image) {
        setState(() {
          _isLoadingImage = false;
        });
        _setBackgroundImage(image);
      });
    } catch (e) {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  void _setBackgroundImage(ui.Image image) {
    ui.Size size = MediaQuery.of(context).size;
    ui.Rect imageRect = ui.Rect.zero;
    bool isLandscape = image.height / image.width < size.height / size.width;
    if (isLandscape) {
      double height = size.height;
      double width = (image.width / image.height) * height;
      double dx = -(width - size.width) / 2;
      double dy = 0;
      imageRect = ui.Rect.fromLTWH(dx, dy, width, height);
    } else {
      double width = size.width;
      double height = (image.height / image.width) * width;
      double dx = 0;
      double dy = -(height - size.height) / 2;
      imageRect = ui.Rect.fromLTWH(dx, dy, width, height);
    }
    setState(() {
      _image = image;
      _imageRect = imageRect;
    });
  }

  void _onAddText() {}

  void _onSave() async {
    if (_image == null) return;
    CustomPainter painter = TextOnImagePainter(
      image: _image!,
      imageRect: _imageRect,
    );
    await savePainterToGallery(context, painter);
  }
}
