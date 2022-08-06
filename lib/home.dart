import 'package:flutter/material.dart';
import 'package:wallpaper_app/emoji_wallpaper.dart';
import 'package:wallpaper_app/gradient_wallpaper.dart';
import 'package:wallpaper_app/text_on_image_wallpaper.dart';

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
                  builder: (context) => const GradientWallpaper(),
                ),
              ),
              child: const Text("Gradient Wallpaper"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmojiWallpapwer(),
                ),
              ),
              child: const Text("Emoji Wallpaper"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TextOnImageWallpaper(),
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
