import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/marks.dart';

typedef MarkCallback = void Function(Mark mark);

class MarkActions extends ConsumerStatefulWidget {
  const MarkActions({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<MarkActions> createState() => _MarkActionsState();
}

class _MarkActionsState extends ConsumerState<MarkActions> {
  void _onDeleteMark(Mark mark) {
    ref.read(marksProvider.notifier).remove(mark);
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        DeleteMarkIntent: CallbackAction<DeleteMarkIntent>(
          onInvoke: (DeleteMarkIntent intent) => _onDeleteMark(intent.mark),
        ),
      },
      child: widget.child,
    );
  }
}

class _MarkIntent extends Intent {
  const _MarkIntent(
    this.mark,
  );

  final Mark mark;
}

class CopyMarkIntent extends _MarkIntent {
  const CopyMarkIntent(
    super.mark,
  );
}

class CutMarkIntent extends _MarkIntent {
  const CutMarkIntent(
    super.mark,
  );
}

class DeleteMarkIntent extends _MarkIntent {
  const DeleteMarkIntent(
    super.mark,
  );
}

class PasteMarkIntent extends Intent {
  const PasteMarkIntent(
  );
}
