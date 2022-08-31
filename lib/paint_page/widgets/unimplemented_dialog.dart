import 'package:flutter/material.dart';

class UnimplementedDialog extends StatelessWidget {
  const UnimplementedDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oops'),
      content: const Text('That is a decoy that\'s not implemented! It\'s a demo, take it easy on me.\n\n Instead, try creating some rectangles with the rectangle tool and using the keyboard to cut/copy/paste/delete. Or use the pointer or text tools.'),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
