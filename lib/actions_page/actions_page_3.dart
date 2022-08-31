import 'package:flutter/material.dart';

import '../demo_page.dart';

class ActionsPageThree extends StatelessWidget {
  const ActionsPageThree({
    super.key,
  });

  static const String route = 'actions-3';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Actions Example - 3 of 3',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/actions_page/actions_page_3.dart'),
      child: Center(
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
          // NEW: A builder to get the BuildContext at this point in the widget
          // tree.
          child: Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () {
                  Actions.invoke<_PushButtonIntent>(context, const _PushButtonIntent());
                },
                child: const Text('Tap me'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PushButtonIntent extends Intent {
  const _PushButtonIntent();
}
