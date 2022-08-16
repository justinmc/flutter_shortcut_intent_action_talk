import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Tool {
  pencil,
  rectangle,
  circle,
}

/// The selections that can be made in the toolbars of the app.
@immutable
class ToolSelections {
  const ToolSelections({
    required this.tool,
    required this.color,
  });

  final Tool tool;
  final Color color;
}

class ToolSelectionsNotifier extends StateNotifier<ToolSelections> {
  ToolSelectionsNotifier(
    ToolSelections selections,
  ) : super(selections);

  /// Similar idea as copyWith.
  void update({
    Tool? tool,
    Color? color,
  }) {
    state = ToolSelections(
      tool: tool ?? state.tool,
      color: color ?? state.color,
    );
  }
}
