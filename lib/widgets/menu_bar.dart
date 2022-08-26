import 'package:flutter/material.dart';
import 'package:flutter_shortcut_intent_action_talk/widgets/toolbar.dart';

import 'unimplemented_dialog.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kUglyGrey,
        child: Row(
        children: const <Widget>[
          _MenuButton(
            text: 'File',
          ),
          _MenuButton(
            text: 'Option',
          ),
          _MenuButton(
            text: 'View',
          ),
          _MenuButton(
            text: 'Image',
          ),
          _MenuButton(
            text: 'Options',
          ),
          _MenuButton(
            text: 'Help',
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const UnimplementedDialog();
          },
        );
      },
      child: Text(text),
    );
  }
}
