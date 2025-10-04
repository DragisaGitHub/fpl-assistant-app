import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../data/fpl_repository.dart';

final fplRepoProvider = Provider<FplRepository>(
      (ref) => FplRepository(ref.watch(dioProvider)),
);

final nextDeadlineProvider = FutureProvider<DateTime?>((ref) async {
  return ref.watch(fplRepoProvider).fetchNextDeadlineUtc();
});

Stream<Duration> _countdownStream(DateTime targetUtc) async* {
  while (true) {
    final diff = targetUtc.difference(DateTime.now().toUtc());
    yield diff;
    if (diff.isNegative) break;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

final countdownProvider =
StreamProvider.autoDispose.family<Duration, DateTime>(
      (ref, targetUtc) => _countdownStream(targetUtc),
);