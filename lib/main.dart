import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'actions_page/actions_page.dart';
import 'actions_page/actions_page_2.dart';
import 'actions_page/actions_page_3.dart';
import 'paint_page/paint_page.dart';
import 'shortcuts_page/shortcuts_page.dart';
import 'shortcuts_page/shortcuts_page_2.dart';
import 'shortcuts_page/shortcuts_page_3.dart';

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
        PaintPage.route: (BuildContext context) => const PaintPage(),
        ActionsPage.route: (BuildContext context) => const ActionsPage(),
        ActionsPageTwo.route: (BuildContext context) => const ActionsPageTwo(),
        ActionsPageThree.route: (BuildContext context) => const ActionsPageThree(),
        ShortcutsPage.route: (BuildContext context) => const ShortcutsPage(),
        ShortcutsPageTwo.route: (BuildContext context) => const ShortcutsPageTwo(),
        ShortcutsPageThree.route: (BuildContext context) => ShortcutsPageThree(),
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
            route: PaintPage.route,
            title: PaintPage.title,
            subtitle: PaintPage.subtitle,
            assetName: 'paint_screenshot.png',
          ),
        ],
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  const MyListItem({
    Key? key,
    required this.route,
    required this.subtitle,
    required this.title,
    required this.assetName,
  }) : super(key: key);

  final String route;
  final String subtitle;
  final String title;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        margin: const EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Image.asset(assetName),
          ),
        ),
      ),
    );
  }
}
