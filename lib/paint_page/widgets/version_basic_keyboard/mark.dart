import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../data/marks.dart';

typedef FocusNodeCallback = Function(FocusNode focusNode);

class MarkWidget extends StatefulWidget {
  const MarkWidget({
    super.key,
    required this.onTapDown,
    required this.onChangeFocus,
    required this.mark,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  final GestureTapDownCallback onTapDown;
  final FocusNodeCallback onChangeFocus;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final Mark mark;

  @override
  State<MarkWidget> createState() => _MarkWidgetState();
}

class _MarkWidgetState extends State<MarkWidget> {
  final FocusNode _focusNode = FocusNode()..requestFocus();

  void _onChangeFocus() {
    if (widget.mark.selected != _focusNode.hasFocus) {
      widget.onChangeFocus(_focusNode);
    }
    //setState(() {});
  }

  void _onTapDown(TapDownDetails details) {
    _focusNode.requestFocus();
    widget.onTapDown(details);
  }

  // NEW: Shortcuts mappings per-platform.
  Map<SingleActivator, Intent> get _commonShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.backspace): const DeleteSelectedMarkIntent(),
  };

  Map<SingleActivator, Intent> get _appleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyA, meta: true): const SelectAllMarksIntent(),
    const SingleActivator(LogicalKeyboardKey.keyC, meta: true): CopyMarkIntent(widget.mark),
    const SingleActivator(LogicalKeyboardKey.keyV, meta: true): const PasteMarkIntent(),
    const SingleActivator(LogicalKeyboardKey.keyX, meta: true): CutMarkIntent(widget.mark),
  };

  Map<SingleActivator, Intent> get _nonAppleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyA, control: true): const SelectAllMarksIntent(),
    const SingleActivator(LogicalKeyboardKey.keyC, control: true): CopyMarkIntent(widget.mark),
    const SingleActivator(LogicalKeyboardKey.keyV, control: true): const PasteMarkIntent(),
    const SingleActivator(LogicalKeyboardKey.keyX, control: true): CutMarkIntent(widget.mark),
  };

  Map<SingleActivator, Intent> get _adaptiveShortcuts {
    switch(defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return <SingleActivator, Intent>{
          ..._commonShortcuts,
          ..._nonAppleShortcuts,
        };
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return <SingleActivator, Intent>{
          ..._commonShortcuts,
          ..._appleShortcuts,
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onChangeFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onChangeFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.mark.rect.topLeft.dx,
      top: widget.mark.rect.topLeft.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onScaleStart: widget.onScaleStart,
        onScaleUpdate: widget.onScaleUpdate,
        onScaleEnd: widget.onScaleEnd,
        // NEW: Shortcuts widget to receive key events on Marks.
        child: Shortcuts(
          shortcuts: _adaptiveShortcuts,
          child: DottedBorder(
            color: widget.mark.selected ? Colors.black : Colors.transparent,
            dashPattern: const <double>[6, 3],
            strokeWidth: 1,
            child: _MarkVisual(
              focusNode: _focusNode,
              mark: widget.mark,
            ),
          ),
        ),
      ),
    );
  }
}

// Build the right Mark for the given Mark.type.
class _MarkVisual extends StatelessWidget {
  const _MarkVisual({
    required this.mark,
    required this.focusNode,
  });

  final FocusNode focusNode;
  final Mark mark;

  @override
  Widget build(BuildContext context) {
    switch (mark.type) {
      case (MarkType.rectangle):
        return _RectangleMark(
          focusNode: focusNode,
          mark: mark,
        );
      case (MarkType.text):
        return _TextMark(
          focusNode: focusNode,
          mark: mark,
        );
    }
  }
}

class _RectangleMark extends StatelessWidget {
  const _RectangleMark({
    required this.mark,
    required this.focusNode,
  });

  final FocusNode focusNode;
  final Mark mark;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Container(
        color: mark.color,
        width: mark.rect.width,
        height: mark.rect.height,
      ),
    );
  }
}

class _TextMark extends StatefulWidget {
  const _TextMark({
    required this.focusNode,
    required this.mark,
  });

  final FocusNode focusNode;
  final Mark mark;

  @override
  _TextMarkState createState() => _TextMarkState();
}

class _TextMarkState extends State<_TextMark> {
  final TextEditingController controller = TextEditingController();

  void _onChangedController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onChangedController);
  }

  @override
  void dispose() {
    controller.removeListener(_onChangedController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: widget.mark.rect.width,
      height: widget.mark.rect.height,
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        focusNode: widget.focusNode,
      ),
    );
  }
}

// NEW: Intents.
class _MarkIntent extends Intent {
  const _MarkIntent(
    this.mark,
  );

  final Mark mark;
}

class CopyMarkIntent extends _MarkIntent {
  const CopyMarkIntent(
    super.mark,
  );
}

class CutMarkIntent extends _MarkIntent {
  const CutMarkIntent(
    super.mark,
  );
}

class DeleteSelectedMarkIntent extends Intent {
  const DeleteSelectedMarkIntent();
}

class PasteMarkIntent extends Intent {
  const PasteMarkIntent(
  );
}

class SelectAllMarksIntent extends Intent {
  const SelectAllMarksIntent();
}
