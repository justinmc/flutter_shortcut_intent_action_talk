import 'package:flutter/material.dart';
import 'package:flutter_shortcut_intent_action_talk/widgets/toolbar.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kUglyGrey,
        child: Row(
        children: <Widget>[
          _MenuButton(
            onPressed: () {},
            text: 'File',
          ),
          _MenuButton(
            onPressed: () {},
            text: 'Option',
          ),
          _MenuButton(
            onPressed: () {},
            text: 'View',
          ),
          _MenuButton(
            onPressed: () {},
            text: 'Image',
          ),
          _MenuButton(
            onPressed: () {},
            text: 'Options',
          ),
          _MenuButton(
            onPressed: () {},
            text: 'Help',
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
