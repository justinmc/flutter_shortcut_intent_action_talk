import 'package:flutter/material.dart';

import '../demo_page.dart';

class QuizActionsNestedPage extends StatelessWidget {
  const QuizActionsNestedPage({
    super.key,
  });

  static const String route = 'quiz-actions-nested';
  static const String title = 'Actions - Nested';
  static const String subtitle = 'Two nested Actions widgets that both map the same Intent.';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - Actions Nested',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_actions_nested.dart'),
      child: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            MyIntent: CallbackAction<MyIntent>(onInvoke: (MyIntent intent) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Invoked Actions higher in the tree.', style: TextStyle(fontSize: 32.0)),
              ));
              return;
            }),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              MyIntent: CallbackAction<MyIntent>(onInvoke: (MyIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked Actions lower in the tree.', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              }),
            },
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Will the Actions higher or lower in the tree be invoked, or both?'),
                    TextButton(
                      onPressed: () {
                        Actions.invoke<MyIntent>(context, const MyIntent());
                      },
                      child: const Text('Tap me'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyIntent extends Intent {
  const MyIntent();
}
