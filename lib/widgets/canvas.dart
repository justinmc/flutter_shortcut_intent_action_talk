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
  Offset? _dragStartLocalFocalPoint;
  Mark? _draggingMark;

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
      _dragStartLocalFocalPoint = details.localFocalPoint;
      _draggingMark = Mark(
        color: selections.color,
        rect: details.localFocalPoint & const Size(1.0, 1.0),
      );
      _selectedMark = _draggingMark;
      ref.read(marksProvider.notifier).create(_draggingMark!);
    });
  }

  void _onScaleUpdate (ScaleUpdateDetails details) {
    if (_draggingMark == null || _dragStartLocalFocalPoint == null) {
      return;
    }
    final Rect nextRect = Rect.fromPoints(
      _dragStartLocalFocalPoint!,
      details.localFocalPoint,
    );
    setState(() {
      _draggingMark = ref.read(marksProvider.notifier)
          .replace(_draggingMark!, nextRect);
      _selectedMark = _draggingMark;
    });
  }

  void _onScaleEnd (ScaleEndDetails details) {
    // TODO(justinmc): Remove marks below some threshold size?
    setState(() {
      _draggingMark = null;
      _dragStartLocalFocalPoint = null;
    });
  }

  void _onTapCanvas() {
    setState(() {
      _selectedMark = null;
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
    required this.rect,
    required this.selected,
  });

  /// Create a [Rectangle] from a [Mark].
  Rectangle.mark({
    super.key,
    required Mark mark,
    required this.onTap,
    required this.selected,
  }) : color = mark.color,
       rect = mark.rect;

  final Color color;
  final VoidCallback onTap;
  final Rect rect;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.topLeft.dx,
      top: rect.topLeft.dy,
      child: GestureDetector(
        onTap: onTap,
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
