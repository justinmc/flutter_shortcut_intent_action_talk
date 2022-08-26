import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MarksNotifier, Set<Mark>> marksProvider =
  StateNotifierProvider<MarksNotifier, Set<Mark>>(
    (StateNotifierProviderRef<MarksNotifier, Set<Mark>> ref) {
      return MarksNotifier();
    },
  );

enum MarkType {
  // circle,
  rectangle,
  text,
}

@immutable
class Mark {
  Mark({
    required this.color,
    required this.rect,
    required this.type,
    int? id,
    this.selected = false,
  }) : id = id ?? randomId;

  final Color color;
  final Rect rect;
  final bool selected;
  final MarkType type;

  final int id;

  static int get randomId => DateTime.now().millisecondsSinceEpoch;

  Mark copyWith({
    Color? color,
    int? id,
    Rect? rect,
    bool? selected,
    MarkType? type,
  }) {
    return Mark(
      id: id ?? this.id,
      color: color ?? this.color,
      rect: rect ?? this.rect,
      selected: selected ?? this.selected,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'Mark($id): $type, $color, $rect';
  }
}

class MarksNotifier extends StateNotifier<Set<Mark>> {
  MarksNotifier(
  ) : super(<Mark>{});

  static Set<Mark> _selectAll(Set<Mark> state) {
    final Set<Mark>nextState = <Mark>{};

    for (Mark mark in state) {
      if (!mark.selected) {
        nextState.add(mark.copyWith(selected: true));
      } else {
        nextState.add(mark);
      }
    }
    return nextState;
  }

  static Set<Mark> _unselectAll(Set<Mark> state) {
    final Set<Mark>nextState = <Mark>{};

    for (Mark mark in state) {
      if (!mark.selected) {
        nextState.add(mark);
      } else {
        nextState.add(mark.copyWith(selected: false));
      }
    }
    return nextState;
  }

  /// True iff there are no duplicate Mark.ids in the state.
  bool _containsNoDuplicateIds() {
    if (state.isEmpty) {
      return true;
    }

    final Set<int>ids = <int>{};

    for (Mark mark in state) {
      ids.add(mark.id);
    }

    return ids.length == state.length;
  }

  /// Removes the given Mark.
  ///
  /// Throws an error if the given Mark doesn't exist.
  void remove(Mark mark) {
    assert(state.contains(mark));
    assert(_containsNoDuplicateIds());

    final Set<Mark> nextState = <Mark>{...state};
    nextState.remove(mark);
    state = nextState;
  }

  /// Removes all selected Marks.
  ///
  /// If none are selected, does nothing.
  void removeSelected() {
    assert(_containsNoDuplicateIds());

    final Set<Mark> nextState = <Mark>{};
    for (Mark mark in state) {
      if (!mark.selected) {
        nextState.add(mark);
      }
    }
    state = nextState;
  }

  /// Replace the given Mark with a new Mark that is the same as the previous
  /// one but with the given values.
  ///
  /// Throws an error if the given Mark doesn't exist.
  Mark replaceWith(Mark mark, {
    Rect? rect,
    bool? selected,
  }) {
    assert(state.contains(mark));
    assert(_containsNoDuplicateIds());

    final Set<Mark> nextState = <Mark>{...state};
    nextState.remove(mark);
    final Mark nextMark = mark.copyWith(
      rect: rect,
      selected: selected,
    );
    nextState.add(nextMark);
    state = nextState;
    return nextMark;
  }

  /// Selects the given Mark and unselects everything else.
  Mark selectOnly(Mark mark) {
    assert(state.contains(mark));
    assert(_containsNoDuplicateIds());

    Set<Mark>nextState = <Mark>{...state};
    nextState.remove(mark);
    nextState = _unselectAll(nextState);
    final Mark nextMark = mark.copyWith(selected: true);
    nextState.add(nextMark);

    state = nextState;

    return nextMark;
  }

  /// Add a new Mark.
  ///
  /// If the given Mark already exists, does nothing.
  ///
  /// When a new Mark is added, all other Marks are unselected.
  void add(Mark mark) {
    assert(_containsNoDuplicateIds());

    if (state.contains(mark)) {
      return;
    }
    state = _unselectAll(state)
        ..add(mark);
  }

  void selectAll() {
    state = _selectAll(state);
  }

  void unselectAll() {
    state = _unselectAll(state);
  }
}
