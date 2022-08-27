import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Version {
  noKeyboard,
  basicKeyboard,
  finished,
}

final StateNotifierProvider<VersionsNotifier, Version> versionProvider =
  StateNotifierProvider<VersionsNotifier, Version>(
    (StateNotifierProviderRef<VersionsNotifier, Version> ref) {
      return VersionsNotifier(Version.finished);
    },
  );

class VersionsNotifier extends StateNotifier<Version> {
  VersionsNotifier(
    Version version,
  ) : super(version);

  /// Similar idea as copyWith.
  void update(Version version) {
    state = version;
  }
}
