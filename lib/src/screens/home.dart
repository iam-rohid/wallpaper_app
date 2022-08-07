import 'package:flutter/material.dart';

import 'editors/create_wallpaper_with_text_on_image.dart';
import 'editors/create_wallpaper_with_emojis.dart';
import 'editors/create_wallpaper_with_gradients.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateWallpaperWithGradients(),
                ),
              ),
              child: const Text("Gradient Wallpaper"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateWallpaperWithEmojis(),
                ),
              ),
              child: const Text("Emoji Wallpaper"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateWallpaperWithTextOnImage(),
                ),
              ),
              child: const Text("Text on Image Wallpaper"),
            ),
          ],
        ),
      ),
    );
  }
}
