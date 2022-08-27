import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo_page.dart';

class TextFieldPageTwo extends StatelessWidget {
  TextFieldPageTwo({
    super.key,
  });

  static const String route = 'text_field-2';

  final TextEditingController controller = TextEditingController(
    text: 'ctrl-a should delete, ctrl-b should select'
  );

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'TextField Example - 2 of 2',
      codeUri: Uri.parse('https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/text_field_page/text_field_page_2.dart'),
      child: Center(
        // NEW: Shortcuts widget to intercept keys that would otherwise go to
        // DefaultTextEditingShortcuts.
        child: Shortcuts(
          shortcuts: const <SingleActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyA, control: true): DeleteCharacterIntent(forward: false),
            SingleActivator(LogicalKeyboardKey.keyA, meta: true): DeleteCharacterIntent(forward: false),
            SingleActivator(LogicalKeyboardKey.keyB, control: true): SelectAllTextIntent(SelectionChangedCause.keyboard),
            SingleActivator(LogicalKeyboardKey.keyB, meta: true): SelectAllTextIntent(SelectionChangedCause.keyboard),
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
