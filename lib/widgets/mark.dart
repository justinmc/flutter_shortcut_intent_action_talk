import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

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
        onTapDown: _onTapDown,
        onScaleStart: widget.onScaleStart,
        onScaleUpdate: widget.onScaleUpdate,
        onScaleEnd: widget.onScaleEnd,
        // TODO(justinmc): Marching ants if you have time...
        child: Shortcuts(
          shortcuts: <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.backspace): DeleteMarkIntent(mark: widget.mark),
          },
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
      // TODO(justinmc): Also do circle?
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
        // TODO(justinmc): Could swap this for Text when not selected.
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          focusNode: widget.focusNode,
        ),
      ),
    );
  }
}

class DeleteMarkIntent extends Intent {
  const DeleteMarkIntent({
    required this.mark,
  });

  final Mark mark;
}
