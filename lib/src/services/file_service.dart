import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

Future<void> savePainterToGallery(
  BuildContext context,
  CustomPainter painter,
) async {
  PictureRecorder recorder = PictureRecorder();
  Canvas canvas = Canvas(recorder);
  double scale = MediaQuery.of(context).devicePixelRatio;
  Size size = MediaQuery.of(context).size * scale;

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
