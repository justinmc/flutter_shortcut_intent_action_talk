import 'package:flutter/material.dart';

const kUglyGrey = Color(0xffe0dfe3);

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 600.0,
      color: kUglyGrey,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: const <Widget>[
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
          ToolButton(
            name: 'tool_pencil.png',
          ),
        ],
      ),
    );
  }
}

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(2.0),
      ),
      onPressed: () {},
      child: Image.asset(
        name,
      ),
    );
  }
}
