import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/canvas.dart';
import 'widgets/menu_bar.dart';
import 'widgets/palette.dart';
import 'widgets/toolbar.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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
              children: const <Widget>[
                Toolbar(),
                Expanded(
                  child: Canvas(),
                ),
              ],
            ),
          ),
          Container(
            color: kUglyGrey,
            height: 160.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Palette(),
                Text('Text and stuff'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
