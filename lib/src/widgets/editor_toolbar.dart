import 'package:flutter/material.dart';

import 'toolbar_item.dart';

class EditorToolbar extends StatelessWidget {
  final List<ToolbarItem> toolbarItems;
  final Function(String) onItemPress;
  final bool isHidden;
  const EditorToolbar({
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
      curve: Curves.easeInOutSine,
      bottom: isHidden ? -barHeightWithPadding : 0,
      left: 0,
      right: 0,
      child: Container(
        height: barHeightWithPadding,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        color: Colors.white,
        child: Row(
          children: toolbarItems
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () => onItemPress(e.tag),
                    child: e,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
