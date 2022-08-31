import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/marks.dart';
import '../../data/tool_selections.dart';
import 'mark.dart';

class Canvas extends ConsumerStatefulWidget {
  const Canvas({
    super.key,
  });

  @override
  ConsumerState<Canvas> createState() => _CanvasState();
}

class _CanvasState extends ConsumerState<Canvas> {
  Offset? _createStartLocalFocalPoint;
  Offset? _translateStartLocalFocalPoint;
  Mark? _creatingMark;
  Mark? _translatingMark;
  final FocusNode _focusNode = FocusNode();

  // Start of a scale gesture on the canvas.
  void _onScaleStart (ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }
    _focusNode.requestFocus();

    final ToolSelections selections = ref.read(selectionsProvider);

    switch (selections.tool) {
      case Tool.circle:
      case Tool.pencil:
      case Tool.pointer:
      case Tool.selection:
      case Tool.text:
        return;
      case Tool.rectangle:
        setState(() {
          _createStartLocalFocalPoint = details.localFocalPoint;
          _creatingMark = Mark(
            color: selections.color,
            rect: details.localFocalPoint & const Size(1.0, 1.0),
            selected: true,
            type: MarkType.rectangle,
          );
          ref.read(marksProvider.notifier).add(_creatingMark!);
        });
        break;
    }
  }

  // Update of a scale gesture on the canvas.
  void _onScaleUpdate (ScaleUpdateDetails details) {
    if (_creatingMark == null || _createStartLocalFocalPoint == null) {
      return;
    }

    final Rect nextRect = Rect.fromPoints(
      _createStartLocalFocalPoint!,
      details.localFocalPoint,
    );
    setState(() {
      _creatingMark = ref.read(marksProvider.notifier)
          .replaceWith(_creatingMark!, rect: nextRect, selected: true);
    });
  }

  // End of a scale gesture on the canvas.
  void _onScaleEnd (ScaleEndDetails details) {
    if (_creatingMark == null || _createStartLocalFocalPoint == null) {
      return;
    }
    setState(() {
      ref.read(selectionsProvider.notifier).update(
        tool: Tool.pointer,
      );
      _creatingMark = null;
      _createStartLocalFocalPoint = null;
    });
  }

  void _onTapUpCanvas(TapUpDetails details) {
    _focusNode.requestFocus();
    final ToolSelections selections = ref.read(selectionsProvider);
    switch (selections.tool) {
      case Tool.circle:
      case Tool.pencil:
      case Tool.selection:
      case Tool.pointer:
      case Tool.rectangle:
        ref.read(marksProvider.notifier).unselectAll();
        return;
      case Tool.text:
        final Mark mark = Mark(
          color: selections.color,
          rect: details.localPosition & const Size(280.0, 80.0),
          selected: true,
          type: MarkType.text,
        );
        ref.read(marksProvider.notifier).add(mark);
        ref.read(selectionsProvider.notifier).update(
          tool: Tool.pointer,
        );
        break;
    }
  }

  void _onTapDownCanvas(TapDownDetails details) {
    ref.read(marksProvider.notifier).unselectAll();
  }

  // Start of a drag gesture on a Mark, i.e. a translation.
  void _onScaleMarkStart(Mark mark, ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }

    final ToolSelections selections = ref.read(selectionsProvider);

    if (selections.tool != Tool.pointer) {
      return;
    }

    setState(() {
      _translateStartLocalFocalPoint = details.localFocalPoint;
      _translatingMark = ref.read(marksProvider.notifier).selectOnly(mark);
    });
  }

  // Update of a drag gesture on a Mark, i.e. a translation.
  void _onScaleMarkUpdate(Mark mark, ScaleUpdateDetails details) {
    if (_translatingMark == null || _translateStartLocalFocalPoint == null) {
      return;
    }

    final Rect nextRect = _translatingMark!.rect.translate(
      details.focalPointDelta.dx,
      details.focalPointDelta.dy,
    );
    setState(() {
      _translatingMark = ref.read(marksProvider.notifier)
          .replaceWith(_translatingMark!, rect: nextRect, selected: true);
    });
  }

  // End of a drag gesture on a Mark, i.e. a translation.
  void _onScaleMarkEnd(Mark mark, ScaleEndDetails details) {
    setState(() {
      _translatingMark = null;
      _translateStartLocalFocalPoint = null;
    });
  }

  void _onTapDownMark(Mark mark) {
    setState(() {
      ref.read(marksProvider.notifier).selectOnly(mark);
    });
  }

  void _onMarkChangeFocus(Mark mark, FocusNode focusNode) {
    final Set<Mark> marks = ref.watch(marksProvider);
    if (focusNode.hasFocus && !mark.selected && marks.contains(mark)) {
      ref.read(marksProvider.notifier).selectOnly(mark);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<Mark> marks = ref.watch(marksProvider);
    final ToolSelections selections = ref.watch(selectionsProvider);

    final bool canTranslate = selections.tool == Tool.pointer;

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onTapUp: _onTapUpCanvas,
      onTapDown: _onTapDownCanvas,
      // TODO: Receive Intents with an Actions widget and update the canvas.
      child: Focus(
        focusNode: _focusNode,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ...marks.map((Mark mark) => MarkWidget(
                key: ValueKey(mark.id),
                mark: mark,
                onChangeFocus: (FocusNode focusNode) => _onMarkChangeFocus(mark, focusNode),
                onScaleStart: canTranslate ? (ScaleStartDetails details) => _onScaleMarkStart(mark, details) : null,
                onScaleUpdate: canTranslate ? (ScaleUpdateDetails details) => _onScaleMarkUpdate(mark, details) : null,
                onScaleEnd: canTranslate ? (ScaleEndDetails details) => _onScaleMarkEnd(mark, details) : null,
                onTapDown: (TapDownDetails details) => _onTapDownMark(mark),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
