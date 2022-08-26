import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tool_selections.dart';
import 'unimplemented_dialog.dart';

const kUglyGrey = Color(0xffe0dfe3);

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kUglyGrey,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Color(0xffaaa69e),
          ),
        ),
      ),
      width: 100.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: const <Widget>[
          _ToolButton(
            tool: Tool.pointer,
          ),
          _ToolButton(
            tool: Tool.selection,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.text,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.rectangle,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
          _ToolButton(
            tool: Tool.circle,
          ),
          _ToolButton(
            tool: Tool.pencil,
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends ConsumerWidget {
  const _ToolButton({
    required this.tool,
  });

  final Tool tool;

  static const _kSelectedColor = Color(0xffffffff);
  static const _kBorderColor = Color(0xff8296a6);

  static const Map<Tool, String> _toolToName = <Tool, String>{
    Tool.pointer: 'tool_pointer.png',
    Tool.circle: 'tool_circle.png',
    Tool.pencil: 'tool_pencil.png',
    Tool.rectangle: 'tool_rectangle.png',
    Tool.selection: 'tool_selection.png',
    Tool.text: 'tool_text.png',
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
        if (Tool.unimplemented.contains(tool)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const UnimplementedDialog();
            },
          );
          return;
        }
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
