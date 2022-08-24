import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';

import '../data/marks.dart';

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
  final FocusNode _focusNode = FocusNode();

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
        // TODO: Support keyboard interactions. Listen with Shortcuts here.
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
    );
  }
}

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
  __TextMarkState createState() => __TextMarkState();
}

class __TextMarkState extends State<_TextMark> {
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Shortcuts(
          shortcuts: <SingleActivator, Intent>{
            if (controller.text.isEmpty)
              const SingleActivator(LogicalKeyboardKey.backspace): DeleteMarkIntent(widget.mark),
          },
          // TODO(justinmc): Could swap this for Text when not selected.
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            focusNode: widget.focusNode,
          ),
        ),
      ),
    );
  }
}

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

class DeleteMarkIntent extends _MarkIntent {
  const DeleteMarkIntent(
    super.mark,
  );
}

class PasteMarkIntent extends Intent {
  const PasteMarkIntent(
  );
}
