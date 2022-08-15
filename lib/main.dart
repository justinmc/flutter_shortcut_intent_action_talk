import 'package:flutter/material.dart';

import 'widgets/toolbar.dart';

void main() {
  runApp(const MyApp());
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('File'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Option'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Image'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Options'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Help'),
              ),
            ],
          ),
          Row(
            children: const <Widget>[
              Toolbar(),
            ],
          ),
        ],
      ),
    );
  }
}
