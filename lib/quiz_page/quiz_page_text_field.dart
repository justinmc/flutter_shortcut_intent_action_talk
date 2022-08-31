import 'package:flutter/material.dart';

import '../demo_page.dart';

class QuizTextFieldPage extends StatelessWidget {
  QuizTextFieldPage({
    super.key,
  });

  static const String route = 'quiz-text-field';
  static const String title = 'TextField override';
  static const String subtitle = 'A TextField wrapped by an Actions widget attempting to override a built-in Intent.';

  final TextEditingController controller = TextEditingController(
    text: 'Focus me and then press ctrl-A or cmd-A',
  );

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Quiz - TextField override',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_text_field.dart'),
      child: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            SelectAllTextIntent: CallbackAction<SelectAllTextIntent>(
              onInvoke: (SelectAllTextIntent intent) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoked SelectAllTextIntent action.', style: TextStyle(fontSize: 32.0)),
                ));
                return;
              },
            ),
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Will the text be selected or will the Actions receive the Intent?'),
              TextField(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
