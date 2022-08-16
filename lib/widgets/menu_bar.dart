import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
          onPressed: () {},
          child: const Text('File'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Option'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('View'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Image'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Options'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Help'),
        ),
      ],
    );
  }
}
