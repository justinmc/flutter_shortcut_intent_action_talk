import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo_page.dart';

class QuizShortcutsNestedPage extends StatelessWidget {
  QuizShortcutsNestedPage({
    super.key,
  });

  static const String route = 'quiz-shortcuts-nested';
  static const String title = 'Shortcuts - Nested';
  static const String subtitle = 'Two nested Shortcuts widgets that both map the same keyboard shortcut.';

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - Shortcuts Nested',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_shortcuts_nested.dart'),
      child: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            MyBackspaceIntent: CallbackAction<MyBackspaceIntent>(
              onInvoke: (MyBackspaceIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked MyBackspaceIntent action.', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            ),
          },
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.backspace): MyBackspaceIntent(),
            },
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.backspace): DoNothingIntent(),
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Will the Actions receive MyBackspaceIntent?'),
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
