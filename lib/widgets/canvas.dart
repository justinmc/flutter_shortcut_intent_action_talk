import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../data/marks.dart';
import '../data/tool_selections.dart';
import 'mark_actions.dart';

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
  Mark? _selectedMark;
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

    // TODO(justinmc): Only the rectangle tool actually works now...
    if (selections.tool != Tool.rectangle) {
      return;
    }

    setState(() {
      _createStartLocalFocalPoint = details.localFocalPoint;
      _creatingMark = Mark(
        color: selections.color,
        rect: details.localFocalPoint & const Size(1.0, 1.0),
      );
      _selectedMark = _creatingMark;
      ref.read(marksProvider.notifier).add(_creatingMark!);
    });
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
          .replace(_creatingMark!, nextRect);
      _selectedMark = _creatingMark;
    });
  }

  // End of a scale gesture on the canvas.
  void _onScaleEnd (ScaleEndDetails details) {
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
  }

  void _onTapDownCanvas(TapDownDetails details) {
    setState(() {
      _selectedMark = null;
    });
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
      _translatingMark = mark;
      _selectedMark = mark;
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
          .replace(_translatingMark!, nextRect);
      _selectedMark = _translatingMark;
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
    // TODO(justinmc): For some reason this doesnt cause any Mark to think that
    // it's selected. Something else getting called and changing the marks?
    setState(() {
      _selectedMark = mark;
      _nextPasteOffset = _selectedMark!.rect.topLeft + _kPasteOffset;
    });
  }

  void _onCopyMark(Mark mark) {
    _copiedMark = mark;
  }

  void _onCutMark(Mark mark) {
    _copiedMark = mark;
    ref.read(marksProvider.notifier).remove(mark);
  }

  void _onPasteMark() {
    if (_copiedMark == null) {
      return;
    }
    final Offset offset = _nextPasteOffset ?? _copiedMark!.rect.topLeft + _kPasteOffset;
    setState(() {
      final Mark pastedMark = _copiedMark!.copyWith(
        rect: offset & _copiedMark!.rect.size,
      );
      ref.read(marksProvider.notifier).add(pastedMark);
      _selectedMark = pastedMark;
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
      // TODO(justinmc): How do I want to organize this, CanvasActions/Shortcuts
      // widgets or move MarkActions into here too?
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
        },
        child: Shortcuts(
          shortcuts: _adaptiveShortcuts,
          child: Focus(
            focusNode: _focusNode,
            child: MarkActions(
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    ...marks.map((Mark mark) => MarkWidget(
                      mark: mark,
                      onScaleStart: canTranslate ? (ScaleStartDetails details) => _onScaleMarkStart(mark, details) : null,
                      onScaleUpdate: canTranslate ? (ScaleUpdateDetails details) => _onScaleMarkUpdate(mark, details) : null,
                      onScaleEnd: canTranslate ? (ScaleEndDetails details) => _onScaleMarkEnd(mark, details) : null,
                      onTapDown: (TapDownDetails details) => _onTapDownMark(mark),
                      selected: _selectedMark == mark,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MarkWidget extends StatelessWidget {
  MarkWidget({
    super.key,
    required this.onTapDown,
    required this.mark,
    required this.selected,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  final GestureTapDownCallback onTapDown;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final Mark mark;
  final bool selected;

  final FocusNode _focusNode = FocusNode();

  Map<SingleActivator, Intent> get _commonShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.backspace): DeleteMarkIntent(mark),
  };

  Map<SingleActivator, Intent> get _appleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyC, meta: true): CopyMarkIntent(mark),
    const SingleActivator(LogicalKeyboardKey.keyX, meta: true): CutMarkIntent(mark),
  };

  Map<SingleActivator, Intent> get _nonAppleShortcuts => <SingleActivator, Intent>{
    const SingleActivator(LogicalKeyboardKey.keyC, control: true): CopyMarkIntent(mark),
    const SingleActivator(LogicalKeyboardKey.keyX, control: true): CutMarkIntent(mark),
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
    // TODO(justinmc): Get rid of selected and just use FocusNodes?
    if (selected && !_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    return Positioned(
      left: mark.rect.topLeft.dx,
      top: mark.rect.topLeft.dy,
      child: GestureDetector(
        onTapDown: onTapDown,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        // TODO(justinmc): Marching ants if you have time...
        child: Shortcuts(
          shortcuts: _adaptiveShortcuts,
          child: Focus(
            focusNode: _focusNode,
            // TODO(justinmc): Also do circle?
            child: Rectangle.mark(
              mark: mark,
              selected: selected,
            ),
          ),
        ),
      ),
    );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle({
    super.key,
    required this.color,
    required this.rect,
    required this.selected,
  });

  /// Create a [Rectangle] from a [Mark].
  Rectangle.mark({
    super.key,
    required Mark mark,
    required this.selected,
  }) : color = mark.color,
       rect = mark.rect;

  final Color color;
  final Rect rect;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: selected ? Colors.black : Colors.transparent,
      dashPattern: const <double>[6, 3],
      strokeWidth: 1,
      child: Container(
        color: color,
        width: rect.width,
        height: rect.height,
      ),
    );
  }
}
