import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tool_selections.dart';

class Palette extends StatefulWidget {
  const Palette({
    super.key,
  });

  @override
  State<Palette> createState() => _PaletteState();
}

class _PaletteState extends State<Palette> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        crossAxisCount: 2,
        children: <Widget>[
          const _Swatch(color: Colors.black),
          const _Swatch(color: Colors.white),
          ...Colors.primaries.map((Color color) => _Swatch(color: color)),
          ...Colors.accents.map((Color color) => _Swatch(color: color)),
        ],
      ),
    );
  }
}

class _Swatch extends ConsumerWidget {
  const _Swatch({
    required this.color
  });

  final Color color;

  static const _kBorderColor = Color(0xffffffff);
  static const _kUglyDarkGrey = Color(0xff9d9da1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ToolSelections selections = ref.watch(selectionsProvider);
    final bool selected = color == selections.color;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(2.0),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? _kBorderColor : _kUglyDarkGrey,
            width: selected ? 3.0 : 2.0,
          ),
        ),
      ),
      onPressed: () {
        ref.read(selectionsProvider.notifier).update(
          color: color,
        );
        ref.read(selectionsProvider.notifier).update(
          tool: Tool.rectangle,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
