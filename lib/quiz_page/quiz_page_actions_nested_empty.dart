import 'package:flutter/material.dart';

import '../demo_page.dart';

class QuizActionsNestedEmptyPage extends StatelessWidget {
  const QuizActionsNestedEmptyPage({
    super.key,
  });

  static const String route = 'quiz-actions-nested-empty';
  static const String title = 'Actions - Nested with Empty';
  static const String subtitle = 'Two nested Actions widgets, only one of which maps the invoked Intent.';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - Actions Nested with Empty',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_actions_nested_empty.dart'),
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
            actions: const <Type, Action<Intent>>{},
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Will the Actions higher in the tree be invoked or not?'),
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

