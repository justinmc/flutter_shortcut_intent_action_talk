import 'package:flutter/material.dart';

import 'shortcuts_page_2.dart';
import '../demo_page.dart';

class ShortcutsPage extends StatelessWidget {
  const ShortcutsPage({
    super.key,
  });

  static const String route = 'shortcuts';
  static const String title = 'Flutter Shortcuts Demo';
  static const String subtitle = 'An example of both Shortcuts and Actions.';

  @override
  Widget build(BuildContext context) {
    return const DemoPage(
      title: 'Shortcuts Example',
      nextRoute: ShortcutsPageTwo.route,
      child: Center(
        // TODO: Add a Shortcuts widget here to receive keys from the button
        // below when it's focused.
        child: Text('Press backspace'),
      ),
    );
  }
}
