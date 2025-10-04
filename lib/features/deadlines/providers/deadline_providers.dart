import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/fpl_api.dart';
import '../data/fpl_repository.dart';

final dioProvider = Provider<Dio>((ref) => buildDio());
final fplRepoProvider = Provider<FplRepository>((ref) => FplRepository(ref.watch(dioProvider)));

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

final countdownProvider = StreamProvider.family<Duration, DateTime>((ref, targetUtc) {
  return _countdownStream(targetUtc);
});