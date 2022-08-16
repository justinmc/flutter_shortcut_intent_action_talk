import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shortcut_intent_action_talk/data/marks.dart';

import 'data/tool_selections.dart';
import 'widgets/canvas.dart';
import 'widgets/menu_bar.dart';
import 'widgets/toolbar.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final StateNotifierProvider<ToolSelectionsNotifier, ToolSelections> selectionsProvider =
  StateNotifierProvider<ToolSelectionsNotifier, ToolSelections>(
    (StateNotifierProviderRef<ToolSelectionsNotifier, ToolSelections> ref) {
      return ToolSelectionsNotifier(const ToolSelections(
        tool: Tool.rectangle,
        color: Colors.black,
      ));
    },
  );

final StateNotifierProvider<MarksNotifier, Set<Mark>> marksProvider =
  StateNotifierProvider<MarksNotifier, Set<Mark>>(
    (StateNotifierProviderRef<MarksNotifier, Set<Mark>> ref) {
      return MarksNotifier();
    },
  );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paint'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const MenuBar(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Toolbar(),
                Expanded(
                  child: Canvas(),
                ),
              ],
            ),
          ),
          Container(
            color: kUglyGrey,
            height: 60.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Text('Color palette'),
                Text('Text and stuff'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
