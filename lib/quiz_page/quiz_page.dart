import 'package:flutter/material.dart';

import 'quiz_page_actions_nested.dart';
import '../my_list_item.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({
    super.key,
  });

  static const String route = 'quiz';
  static const String title = 'Quiz Questions';
  static const String subtitle = 'All of the quiz questions, runnable.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ListView(
        children: const <Widget>[
          MyListItem(
            route: QuizActionsNestedPage.route,
            title: QuizActionsNestedPage.title,
            subtitle: QuizActionsNestedPage.subtitle,
          ),
        ],
      ),
    );
  }
}

