import 'package:flutter/material.dart';

import 'actions_page_3.dart';
import '../demo_page.dart';

class ActionsPageTwo extends StatelessWidget {
  const ActionsPageTwo({
    super.key,
  });

  static const String route = 'actions-2';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Actions Example - 2 of 3',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/actions_page/actions_page_2.dart'),
      nextRoute: ActionsPageThree.route,
      child: Center(
        // NEW: Actions widget to listen for _PushButtonIntent.
        child: Actions(
          actions: <Type, Action<Intent>>{
            _PushButtonIntent: CallbackAction<_PushButtonIntent>(
              onInvoke: (_PushButtonIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked _PushButtonIntent', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            ),
          },
          child: TextButton(
            onPressed: () {
              // NEW: Invoke the new _PushButtonIntent when pressed.
              Actions.invoke<_PushButtonIntent>(context, const _PushButtonIntent());
            },
            child: const Text('Tap me'),
          ),
        ),
      ),
    );
  }
}

// NEW: An Intent to invoke.
class _PushButtonIntent extends Intent {
  const _PushButtonIntent();
}
