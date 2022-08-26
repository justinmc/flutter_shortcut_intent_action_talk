import 'package:flutter/material.dart';

/// Just abstracting some common boilerplate from each page.
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.child,
    required this.title,
    this.nextRoute,
  });

  final Widget child;
  final String title;
  final String? nextRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          if (nextRoute != null)
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.pushNamed(context, nextRoute!);
              },
            ),
        ],
      ),
      body: child,
    );
  }
}
