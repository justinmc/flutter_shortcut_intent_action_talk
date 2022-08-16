import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Offset? _dragStartLocalFocalPoint;
  Mark? _draggingMark;

  void _onScaleStart (ScaleStartDetails details) {
    if (details.pointerCount != 1) {
      return;
    }

    final ToolSelections selections = ref.read(selectionsProvider);
    _dragStartLocalFocalPoint = details.localFocalPoint;
    _draggingMark = Mark(
      color: selections.color,
      rect: details.localFocalPoint & const Size(1.0, 1.0),
    );
    ref.read(marksProvider.notifier).create(_draggingMark!);
  }

  void _onScaleUpdate (ScaleUpdateDetails details) {
    if (_draggingMark == null || _dragStartLocalFocalPoint == null) {
      return;
    }
    final Rect nextRect = Rect.fromPoints(
      _dragStartLocalFocalPoint!,
      details.localFocalPoint,
    );
    _draggingMark = ref.read(marksProvider.notifier)
        .replace(_draggingMark!, nextRect);
  }

  void _onScaleEnd (ScaleEndDetails details) {
    _draggingMark = null;
    _dragStartLocalFocalPoint = null;
  }

  @override
  Widget build(BuildContext context) {
    final Set<Mark> marks = ref.watch(marksProvider);

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            ...marks.map((Mark mark) => Rectangle.mark(mark: mark)),
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
    required this.rect,
  });

  /// Create a [Rectangle] from a [Mark].
  Rectangle.mark({
    super.key,
    required Mark mark,
  }) : color = mark.color,
       rect = mark.rect;

  final Color color;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.topLeft.dx,
      top: rect.topLeft.dy,
      child: Container(
        width: rect.width,
        height: rect.height,
        color: color,
      ),
    );
  }
}
