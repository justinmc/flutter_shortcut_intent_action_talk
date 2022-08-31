import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shortcuts_page_3.dart';
import '../demo_page.dart';

class ShortcutsPageTwo extends StatelessWidget {
  const ShortcutsPageTwo({
    super.key,
  });

  static const String route = 'shortcuts-2';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Shortcuts Example - 2 of 3',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/shortcuts_page/shortcuts_page_2.dart'),
      nextRoute: ShortcutsPageThree.route,
      child: Center(
        // NEW: An Actions widget to recieve _BackspaceIntent.
        child: Actions(
          actions: <Type, Action<Intent>>{
            _BackspaceIntent: CallbackAction<_BackspaceIntent>(
              onInvoke: (_BackspaceIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked _BackspaceIntent', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            ),
          },
          // NEW: An Shortcuts widget to receive the backspace key.
          child: const Shortcuts(
            shortcuts: <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.backspace): _BackspaceIntent(),
            },
            child: Text('Press backspace'),
          ),
        ),
      ),
    );
  }
}

// NEW: An Intent to trigger based on some keyboard shortcut (backspace).
class _BackspaceIntent extends Intent {
  const _BackspaceIntent();
}
