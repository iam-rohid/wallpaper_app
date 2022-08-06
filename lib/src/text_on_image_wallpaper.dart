import 'package:flutter/material.dart';

class TextOnImageWallpaper extends StatefulWidget {
  const TextOnImageWallpaper({Key? key}) : super(key: key);

  @override
  State<TextOnImageWallpaper> createState() => _TextOnImageWallpaperState();
}

class _TextOnImageWallpaperState extends State<TextOnImageWallpaper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Text On ImageWallpaper"),
      ),
    );
  }
}
