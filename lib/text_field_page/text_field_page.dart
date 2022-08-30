import 'package:flutter/material.dart';

import 'text_field_page_2.dart';
import '../demo_page.dart';

class TextFieldPage extends StatelessWidget {
  TextFieldPage({
    super.key,
  });

  static const String route = 'text_field';
  static const String title = 'TextField Demo';
  static const String subtitle = "An example of modifying TextField's built-in keyboard behavior.";

  final TextEditingController controller = TextEditingController(
    text: 'ctrl-a should delete, ctrl-b should select'
  );

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'TextField Example - 1 of 2',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/text_field_page/text_field_page.dart'),
      nextRoute: TextFieldPageTwo.route,
      child: Center(
        // TODO: Modify the keyboard shortcut behavior of the TextField.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
