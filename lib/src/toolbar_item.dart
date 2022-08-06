import 'package:flutter/material.dart';

class ToolbarItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final String tag;
  const ToolbarItem({
    Key? key,
    required this.tag,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: const IconThemeData(
              color: Colors.black,
              size: 28,
            ),
            child: icon,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
