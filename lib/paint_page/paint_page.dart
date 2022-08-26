import 'package:flutter/material.dart';

import 'widgets/canvas.dart';
import 'widgets/menu_bar.dart';
import 'widgets/palette.dart';
import 'widgets/toolbar.dart';

class PaintPage extends StatelessWidget {
  const PaintPage({
    super.key,
  });

  static const String route = 'paint';
  static const String title = 'Flutter Paint Demo';
  static const String subtitle = 'A simple drawing app with keyboard shortcuts.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paint'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const MenuBar(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Toolbar(),
                Expanded(
                  child: Canvas(),
                ),
              ],
            ),
          ),
          Container(
            color: kUglyGrey,
            height: 160.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Palette(),
                Text('Text and stuff'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
