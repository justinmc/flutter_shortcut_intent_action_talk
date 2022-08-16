import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shortcut_intent_action_talk/main.dart';

import '../data/tool_selections.dart';

const kUglyGrey = Color(0xffe0dfe3);

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kUglyGrey,
      width: 100.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: const <Widget>[
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.rectangle,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
          ToolButton(
            tool: Tool.circle,
          ),
          ToolButton(
            tool: Tool.pencil,
          ),
        ],
      ),
    );
  }
}

class ToolButton extends ConsumerWidget {
  const ToolButton({
    super.key,
    required this.tool,
  });

  final Tool tool;

  static const _kSelectedColor = Color(0xffffffff);
  static const _kBorderColor = Color(0xff8296a6);

  static const Map<Tool, String> _toolToName = <Tool, String>{
    Tool.pencil: 'tool_pencil.png',
    Tool.rectangle: 'tool_rectangle.png',
    Tool.circle: 'tool_circle.png',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ToolSelections selections = ref.watch(selectionsProvider);
    final bool selected = tool == selections.tool;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(2.0),
        backgroundColor: selected ? _kSelectedColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: BorderSide(
            color: selected ? _kBorderColor : Colors.transparent,
          ),
        ),
      ),
      onPressed: () {
        ref.read(selectionsProvider.notifier).update(
          tool: tool,
        );
      },
      child: Image.asset(
        _toolToName[tool]!,
      ),
    );
  }
}
