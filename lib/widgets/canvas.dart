import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../data/marks.dart';
import '../data/tool_selections.dart';

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

  void _onScaleStart (ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }

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
      ref.read(marksProvider.notifier).create(_creatingMark!);
    });
  }

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

  void _onScaleEnd (ScaleEndDetails details) {
    // TODO(justinmc): Remove marks below some threshold size?
    setState(() {
      _creatingMark = null;
      _createStartLocalFocalPoint = null;
    });
  }

  void _onTapCanvas() {
    setState(() {
      _selectedMark = null;
    });
  }

  void _onScaleMarkStart(Mark mark, ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }

    // TODO(justinmc): Restrictions on which tools can drag a mark?

    setState(() {
      _translateStartLocalFocalPoint = details.localFocalPoint;
      _translatingMark = mark;
      _selectedMark = mark;
    });
  }

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

  void _onScaleMarkEnd(Mark mark, ScaleEndDetails details) {
    setState(() {
      _translatingMark = null;
      _translateStartLocalFocalPoint = null;
    });
  }

  void _onTapMark(Mark mark) {
    // TODO(justinmc): Should tap to select only work for certain tools?
    setState(() {
      _selectedMark = mark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Set<Mark> marks = ref.watch(marksProvider);

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onTap: _onTapCanvas,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            ...marks.map((Mark mark) => Rectangle.mark(
              mark: mark,
              onScaleStart: (ScaleStartDetails details) => _onScaleMarkStart(mark, details),
              onScaleUpdate: (ScaleUpdateDetails details) => _onScaleMarkUpdate(mark, details),
              onScaleEnd: (ScaleEndDetails details) => _onScaleMarkEnd(mark, details),
              onTap: () => _onTapMark(mark),
              selected: _selectedMark == mark,
            )),
          ],
        ),
      ),
    );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle({
    super.key,
    required this.color,
    required this.onTap,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
    required this.rect,
    required this.selected,
  });

  /// Create a [Rectangle] from a [Mark].
  Rectangle.mark({
    super.key,
    required Mark mark,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
    required this.onTap,
    required this.selected,
  }) : color = mark.color,
       rect = mark.rect;

  final Color color;
  final VoidCallback onTap;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final GestureScaleEndCallback onScaleEnd;
  final Rect rect;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.topLeft.dx,
      top: rect.topLeft.dy,
      child: GestureDetector(
        onTap: onTap,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        // TODO(justinmc): Marching ants if you have time...
        child: DottedBorder(
          color: selected ? Colors.black : Colors.transparent,
          dashPattern: const <double>[6, 3],
          strokeWidth: 1,
          child: Container(
            color: color,
            width: rect.width,
            height: rect.height,
          ),
        ),
      ),
    );
  }
}
