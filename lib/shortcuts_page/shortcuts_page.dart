import 'package:flutter/material.dart';

import 'shortcuts_page_2.dart';
import '../demo_page.dart';

class ShortcutsPage extends StatelessWidget {
  const ShortcutsPage({
    super.key,
  });

  static const String route = 'shortcuts';
  static const String title = 'Shortcuts Demo';
  static const String subtitle = 'An example of both Shortcuts and Actions.';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Shortcuts Example - 1 of 3',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/shortcuts_page/shortcuts_page.dart'),
      nextRoute: ShortcutsPageTwo.route,
      child: const Center(
        // TODO: Add a Shortcuts widget here to receive the backspace key.
        child: Text('Press backspace'),
      ),
    );
  }
}
