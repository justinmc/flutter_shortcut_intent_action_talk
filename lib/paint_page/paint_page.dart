import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/version.dart';
import 'widgets/canvas.dart';
import 'widgets/version_no_keyboard/canvas.dart' as canvas_no_keyboard;
import 'widgets/version_basic_keyboard/canvas.dart' as canvas_basic_keyboard;
import 'widgets/menu_bar.dart';
import 'widgets/palette.dart';
import 'widgets/toolbar.dart';

class PaintPage extends ConsumerWidget {
  const PaintPage({
    super.key,
  });

  static const String route = 'paint';
  static const String title = 'Flutter Paint Demo';
  static const String subtitle = 'A simple drawing app with keyboard shortcuts.';

  static Widget _canvasForVersion(Version version) {
    switch (version) {
      case (Version.noKeyboard):
        return const canvas_no_keyboard.Canvas();
      case (Version.basicKeyboard):
        return const canvas_basic_keyboard.Canvas();
      case (Version.finished):
        return const Canvas();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Version version = ref.watch(versionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paint'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const _VersionSelector();
                },
              );
            },
          ),
        ],
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
                  child: _canvasForVersion(version),
                ),
              ],
            ),
          ),
          Container(
            color: kUglyGrey,
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Palette(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionSelector extends ConsumerWidget {
  const _VersionSelector();

  static const Map<Version, String> _versionTitles = <Version, String>{
    Version.noKeyboard: 'No keyboard functionality',
    Version.basicKeyboard: 'Basic keyboard functionality',
    Version.finished: 'The final, fully featured app',
  };

  static const Map<Version, String> _versionCanvasUris = <Version, String>{
    Version.noKeyboard: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/version_no_keyboard/canvas.dart',
    Version.basicKeyboard: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/version_basic_keyboard/canvas.dart',
    Version.finished: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/canvas.dart',
  };

  static const Map<Version, String> _versionMarkUris = <Version, String>{
    Version.noKeyboard: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/version_no_keyboard/mark.dart',
    Version.basicKeyboard: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/version_basic_keyboard/mark.dart',
    Version.finished: 'https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/paint_page/widgets/mark.dart',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Version selectedVersion = ref.watch(versionProvider);

    return SimpleDialog(
      title: const Text('App versions'),
      children: Version.values.map((Version version) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  ref.read(versionProvider.notifier).update(version);
                },
                child: Row(
                  children: <Widget>[
                    Icon(version == selectedVersion ? Icons.check_box_outlined : Icons.check_box_outline_blank),
                    Text(_versionTitles[version]!),
                  ],
                ),
              ),
              const Spacer(flex: 2),
                  IconButton(
                    icon: const Icon(Icons.code),
                    tooltip: 'canvas.dart',
                    onPressed: () async {
                      final Uri url = Uri.parse(_versionCanvasUris[version]!);
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.code),
                    tooltip: 'mark.dart',
                    onPressed: () async{
                      final Uri url = Uri.parse(_versionMarkUris[version]!);
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
