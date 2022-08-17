import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MarksNotifier, Set<Mark>> marksProvider =
  StateNotifierProvider<MarksNotifier, Set<Mark>>(
    (StateNotifierProviderRef<MarksNotifier, Set<Mark>> ref) {
      return MarksNotifier();
    },
  );

@immutable
class Mark {
  const Mark({
    required this.color,
    required this.rect,
  });

  final Color color;
  final Rect rect;

  Mark copyWith({
    Color? color,
    Rect? rect,
  }) {
    return Mark(
      color: color ?? this.color,
      rect: rect ?? this.rect,
    );
  }

  @override
  String toString() {
    return 'Mark $color, $rect';
  }
}

class MarksNotifier extends StateNotifier<Set<Mark>> {
  MarksNotifier(
  ) : super(<Mark>{});

  /// Add a new Mark.
  ///
  /// If the given Mark already exists, does nothing.
  void add(Mark mark) {
    if (state.contains(mark)) {
      return;
    }
    state = <Mark>{
      ...state,
      mark,
    };
  }

  /// Removes the given Mark.
  ///
  /// Throws an error if the given Mark doesn't exist.
  void remove(Mark mark) {
    if (!state.contains(mark)) {
      throw FlutterError('Given mark not found.');
    }

    final Set<Mark> nextState = <Mark>{...state};
    nextState.remove(mark);
    state = nextState;
  }

  /// Replace the given Mark with a new Mark that is the same as the previous
  /// one but with the given `rect`.
  ///
  /// Throws an error if the given Mark doesn't exist.
  Mark replace(Mark mark, Rect rect) {
    if (!state.contains(mark)) {
      throw FlutterError('Given mark not found.');
    }

    final Set<Mark> nextState = <Mark>{...state};
    nextState.remove(mark);
    final Mark nextMark = mark.copyWith(rect: rect);
    nextState.add(nextMark);
    state = nextState;
    return nextMark;
  }
}
