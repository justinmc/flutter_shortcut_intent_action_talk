import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/marks.dart';
import '../data/tool_selections.dart';
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
    // TODO(justinmc): Remove marks below some threshold size?
    setState(() {
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
          rect: details.localPosition & const Size(200.0, 60.0),
          selected: true,
          type: MarkType.text,
        );
        ref.read(marksProvider.notifier).add(mark);
        break;
    }
  }

  void _onTapDownCanvas(TapDownDetails details) {
    // TODO(justinmc): This is sometimes called after tapping a Mark.
    ref.read(marksProvider.notifier).unselectAll();
  }

  // Start of a drag gesture on a Mark, i.e. a translation.
  void _onScaleMarkStart(Mark mark, ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }

    final ToolSelections selections = ref.read(selectionsProvider);

    if (selections.tool != Tool.selection) {
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
    // TODO(justinmc): Should tap to select only work for certain tools?
    setState(() {
      ref.read(marksProvider.notifier).selectOnly(mark);
      _nextPasteOffset = mark.rect.topLeft + _kPasteOffset;
    });
  }

  void _onMarkChangeFocus(Mark mark, FocusNode focusNode) {
    /*
    if (focusNode.hasFocus && !mark.selected) {
      ref.read(marksProvider.notifier).selectOnly(mark);
    }
    */
  }

  void _onCopyMark(Mark mark) {
    _copiedMark = mark;
  }

  void _onCutMark(Mark mark) {
    _copiedMark = mark;
    ref.read(marksProvider.notifier).remove(mark);
  }

  void _onDeleteMark(Mark mark) {
    ref.read(marksProvider.notifier).remove(mark);
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

  Map<SingleActivator, Intent> get _commonShortcuts => <SingleActivator, Intent>{
  };

  Map<SingleActivator, Intent> get _appleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyV, meta: true): const PasteMarkIntent(),
  };

  Map<SingleActivator, Intent> get _nonAppleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyV, control: true): const PasteMarkIntent(),
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
  Widget build(BuildContext context) {
    final Set<Mark> marks = ref.watch(marksProvider);
    final ToolSelections selections = ref.watch(selectionsProvider);

    final bool canTranslate = selections.tool == Tool.selection;

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onTapUp: _onTapUpCanvas,
      onTapDown: _onTapDownCanvas,
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
          DeleteMarkIntent: CallbackAction<DeleteMarkIntent>(
            onInvoke: (DeleteMarkIntent intent) => _onDeleteMark(intent.mark),
          ),
        },
        child: Shortcuts(
          shortcuts: _adaptiveShortcuts,
          child: Focus(
            focusNode: _focusNode,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  // TODO(justinmc): Sort by created or interacted timestamp.
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
      ),
    );
  }
}
