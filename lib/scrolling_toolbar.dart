import 'package:flutter/material.dart';
import 'package:wallpaper_app/toolbar_item.dart';

class ScrollingToolBar extends StatelessWidget {
  final List<ToolbarItem> toolbarItems;
  final Function(int) onItemPress;
  final bool isHidden;
  const ScrollingToolBar({
    Key? key,
    required this.toolbarItems,
    required this.onItemPress,
    this.isHidden = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int barHeight = 56;
    double barHeightWithPadding =
        MediaQuery.of(context).padding.bottom + barHeight;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      bottom: isHidden ? -barHeightWithPadding : 0,
      left: 0,
      right: 0,
      child: Container(
        height: barHeightWithPadding,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        color: Colors.white.withOpacity(0.5),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: toolbarItems.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => onItemPress(index),
            child: toolbarItems[index],
          ),
        ),
      ),
    );
  }
}
