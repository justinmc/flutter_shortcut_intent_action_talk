import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo_page.dart';

class ShortcutsPageThree extends StatelessWidget {
  ShortcutsPageThree({
    super.key,
  });

  static const String route = 'shortcuts-3';

  // NEW: We need a FocusNode to set the focus from which our keystrokes will be
  // read.
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Shortcuts Example - 3 of 3',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/shortcuts_page/shortcuts_page_3.dart'),
      child: Center(
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
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.backspace): _BackspaceIntent(),
            },
            // NEW: This button sets its focus when tapped so that the Shortcuts
            // above can pick up keyboard events.
            child: TextButton(
              focusNode: _focusNode,
              onPressed: () {
                _focusNode.requestFocus();
              },
              child: const Text('Tap me, then press backspace'),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackspaceIntent extends Intent {
  const _BackspaceIntent();
}

