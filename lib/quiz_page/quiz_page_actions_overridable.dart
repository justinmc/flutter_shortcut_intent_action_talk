import 'package:flutter/material.dart';

import '../demo_page.dart';

class QuizActionsOverridablePage extends StatelessWidget {
  const QuizActionsOverridablePage({
    super.key,
  });

  static const String route = 'quiz-actions-overridable';
  static const String title = 'Overridable Actions';
  static const String subtitle = 'A demonstration of Actions.overridable.';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - Overridable Actions',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_actions_overridable.dart'),
      child: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            _PushButtonIntent: Action<_PushButtonIntent>.overridable(context: context, defaultAction: CallbackAction<_PushButtonIntent>(
              onInvoke: (_PushButtonIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked higher overridable _PushButtonIntent', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            )),
          },
          child: Builder(
            builder: (BuildContext context) {
              return Actions(
                actions: <Type, Action<Intent>>{
                  _PushButtonIntent: Action<_PushButtonIntent>.overridable(context: context, defaultAction: CallbackAction<_PushButtonIntent>(
                    onInvoke: (_PushButtonIntent intent) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invoked lower overridable _PushButtonIntent', style: TextStyle(fontSize: 32.0)),
                      ));
                      return;
                    },
                  )),
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Which overridable Action will be invoked?'),
                    Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                          onPressed: () {
                            Actions.invoke<_PushButtonIntent>(context, const _PushButtonIntent());
                          },
                          child: const Text('Tap me'),
                        );
                      },
                    ),
                  ],
                ),
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
