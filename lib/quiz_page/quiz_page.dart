import 'package:flutter/material.dart';

import 'quiz_page_actions_nested.dart';
import 'quiz_page_actions_nested_empty.dart';
import 'quiz_page_shortcuts_nested.dart';
import 'quiz_page_shortcuts_sandwiched.dart';
import 'quiz_page_text_field.dart';
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
          MyListItem(
            route: QuizActionsNestedEmptyPage.route,
            title: QuizActionsNestedEmptyPage.title,
            subtitle: QuizActionsNestedEmptyPage.subtitle,
          ),
          MyListItem(
            route: QuizShortcutsNestedPage.route,
            title: QuizShortcutsNestedPage.title,
            subtitle: QuizShortcutsNestedPage.subtitle,
          ),
          MyListItem(
            route: QuizShortcutsSandwichedPage.route,
            title: QuizShortcutsSandwichedPage.title,
            subtitle: QuizShortcutsSandwichedPage.subtitle,
          ),
          MyListItem(
            route: QuizTextFieldPage.route,
            title: QuizTextFieldPage.title,
            subtitle: QuizTextFieldPage.subtitle,
          ),
        ],
      ),
    );
  }
}

