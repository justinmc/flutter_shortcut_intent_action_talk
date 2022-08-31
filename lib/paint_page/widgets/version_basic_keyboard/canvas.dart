import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/marks.dart';
import '../../data/tool_selections.dart';
import 'mark.dart';

// The distance to offset a paste from a specific location (to avoid things
// being invisibly directly on top of each other).
const Offset _kPasteOffset = Offset(20.0, 20.0);

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
  Mark? _copiedMark;
  Offset? _nextPasteOffset;
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
      _nextPasteOffset = _creatingMark!.rect.topLeft + _kPasteOffset;
      _creatingMark = null;
      _createStartLocalFocalPoint = null;
    });
  }

  void _onTapUpCanvas(TapUpDetails details) {
    _nextPasteOffset = details.localPosition;
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
      _nextPasteOffset = mark.rect.topLeft + _kPasteOffset;
    });
  }

  void _onMarkChangeFocus(Mark mark, FocusNode focusNode) {
    final Set<Mark> marks = ref.watch(marksProvider);
    if (focusNode.hasFocus && !mark.selected && marks.contains(mark)) {
      ref.read(marksProvider.notifier).selectOnly(mark);
    }
  }

  // NEW: Handlers for Actions.
  void _onCopyMark(Mark mark) {
    _copiedMark = mark;
  }

  void _onCutMark(Mark mark) {
    _copiedMark = mark;
    ref.read(marksProvider.notifier).remove(mark);
  }

  void _onDeleteSelectedMark() {
    ref.read(marksProvider.notifier).removeSelected();
  }

  void _selectAllMarks() {
    ref.read(marksProvider.notifier).selectAll();
  }

  void _onPasteMark() {
    if (_copiedMark == null) {
      return;
    }
    final Offset offset = _nextPasteOffset ?? _copiedMark!.rect.topLeft + _kPasteOffset;
    setState(() {
      final Mark pastedMark = _copiedMark!.copyWith(
        id: Mark.randomId,
        rect: offset & _copiedMark!.rect.size,
        selected: true,
      );
      ref.read(marksProvider.notifier).add(pastedMark);
      _nextPasteOffset = offset + _kPasteOffset;
    });
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
      // NEW: The canvas receives Intents with this Actions widget.
      child: Actions(
        actions: <Type, Action<Intent>>{
          CopyMarkIntent: CallbackAction<CopyMarkIntent>(
            onInvoke: (CopyMarkIntent intent) => _onCopyMark(intent.mark),
          ),
          CutMarkIntent: CallbackAction<CutMarkIntent>(
            onInvoke: (CutMarkIntent intent) => _onCutMark(intent.mark),
          ),
          PasteMarkIntent: CallbackAction<PasteMarkIntent>(
            onInvoke: (PasteMarkIntent intent) => _onPasteMark(),
          ),
          DeleteSelectedMarkIntent: CallbackAction<DeleteSelectedMarkIntent>(
            onInvoke: (DeleteSelectedMarkIntent intent) => _onDeleteSelectedMark(),
          ),
          SelectAllMarksIntent: CallbackAction<SelectAllMarksIntent>(
            onInvoke: (SelectAllMarksIntent intent) => _selectAllMarks(),
          ),
        },
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
      ),
    );
  }
}
