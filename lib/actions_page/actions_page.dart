import 'package:flutter/material.dart';

import 'actions_page_2.dart';
import '../demo_page.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({
    super.key,
  });

  static const String route = 'actions';
  static const String title = 'Flutter Actions Demo';
  static const String subtitle = 'An example of just the Actions widget by itself.';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Actions Example',
      nextRoute: ActionsPageTwo.route,
      child: Center(
        child: TextButton(
          onPressed: () {
            // TODO: Invoke an Intent when pressed and receive it above.
          },
          child: const Text('Tap me'),
        ),
      ),
    );
  }
}
