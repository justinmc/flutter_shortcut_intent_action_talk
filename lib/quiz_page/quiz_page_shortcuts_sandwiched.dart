import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo_page.dart';

class QuizShortcutsSandwichedPage extends StatelessWidget {
  QuizShortcutsSandwichedPage({
    super.key,
  });

  static const String route = 'quiz-shortcuts-sandwiched';
  static const String title = 'Shortcuts - Sandwiched';
  static const String subtitle = 'A Shortcuts widget surrounded by two Actions widgets that all map the same Intent.';

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - Shortcuts Surrounded by Actions',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_shortcuts_sandwiched.dart'),
      child: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            MyBackspaceIntent: CallbackAction<MyBackspaceIntent>(
              onInvoke: (MyBackspaceIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked MyBackspaceIntent action in Actions higher in the tree.', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            ),
          },
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.backspace): MyBackspaceIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                MyBackspaceIntent: CallbackAction<MyBackspaceIntent>(
                  onInvoke: (MyBackspaceIntent intent) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invoked MyBackspaceIntent in Actions lower in the tree.', style: TextStyle(fontSize: 32.0)),
                    ));
                    return;
                  },
                ),
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Will the higher or lower Actions receive MyBackspaceIntent?'),
                  TextButton(
                    focusNode: _focusNode,
                    onPressed: () => _focusNode.requestFocus(),
                    child: const Text('Tap me, then press backspace'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyBackspaceIntent extends Intent {
  const MyBackspaceIntent();
}
