import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

/// Just abstracting some common boilerplate from each page.
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.child,
    required this.codeUri,
    required this.title,
    this.nextRoute,
  });

  final Widget child;
  final Uri codeUri;
  final String title;
  final String? nextRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () async {
              if (!await launchUrl(codeUri)) {
                throw 'Could not launch $codeUri';
              }
            },
          ),
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
