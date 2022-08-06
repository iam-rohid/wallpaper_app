import 'package:flutter/material.dart';

class LockScreenOverlay extends StatelessWidget {
  const LockScreenOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        "assets/images/lock_screen_overlay.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
