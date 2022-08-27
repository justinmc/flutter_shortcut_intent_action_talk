import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shortcut_intent_action_talk/quiz_page/quiz_page_actions_nested_empty.dart';

import 'actions_page/actions_page.dart';
import 'actions_page/actions_page_2.dart';
import 'actions_page/actions_page_3.dart';
import 'my_list_item.dart';
import 'paint_page/paint_page.dart';
import 'quiz_page/quiz_page.dart';
import 'quiz_page/quiz_page_actions_nested.dart';
import 'shortcuts_page/shortcuts_page.dart';
import 'shortcuts_page/shortcuts_page_2.dart';
import 'shortcuts_page/shortcuts_page_3.dart';
import 'text_field_page/text_field_page.dart';
import 'text_field_page/text_field_page_2.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Validation Sandbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, Widget Function(BuildContext)>{
        '/': (BuildContext context) => const MyHomePage(),
        ActionsPage.route: (BuildContext context) => const ActionsPage(),
        ActionsPageTwo.route: (BuildContext context) => const ActionsPageTwo(),
        ActionsPageThree.route: (BuildContext context) => const ActionsPageThree(),
        PaintPage.route: (BuildContext context) => const PaintPage(),
        QuizPage.route: (BuildContext context) => const QuizPage(),
        QuizActionsNestedPage.route: (BuildContext context) => const QuizActionsNestedPage(),
        QuizActionsNestedEmptyPage.route: (BuildContext context) => const QuizActionsNestedEmptyPage(),
        ShortcutsPage.route: (BuildContext context) => const ShortcutsPage(),
        ShortcutsPageTwo.route: (BuildContext context) => const ShortcutsPageTwo(),
        ShortcutsPageThree.route: (BuildContext context) => ShortcutsPageThree(),
        TextFieldPage.route: (BuildContext context) => TextFieldPage(),
        TextFieldPageTwo.route: (BuildContext context) => TextFieldPageTwo(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ContextualMenu Demos'),
      ),
      body: ListView(
        children: const <Widget>[
          MyListItem(
            route: ActionsPage.route,
            title: ActionsPage.title,
            subtitle: ActionsPage.subtitle,
            assetName: 'actions_screenshot.png',
          ),
          MyListItem(
            route: ShortcutsPage.route,
            title: ShortcutsPage.title,
            subtitle: ShortcutsPage.subtitle,
            assetName: 'shortcuts_screenshot.png',
          ),
          MyListItem(
            route: TextFieldPage.route,
            title: TextFieldPage.title,
            subtitle: TextFieldPage.subtitle,
            assetName: 'text_field_screenshot.png',
          ),
          MyListItem(
            route: PaintPage.route,
            title: PaintPage.title,
            subtitle: PaintPage.subtitle,
            assetName: 'paint_screenshot.png',
          ),
          MyListItem(
            route: QuizPage.route,
            title: QuizPage.title,
            subtitle: QuizPage.subtitle,
          ),
        ],
      ),
    );
  }
}
