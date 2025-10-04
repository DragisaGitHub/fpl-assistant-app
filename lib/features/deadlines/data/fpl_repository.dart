import 'package:dio/dio.dart';
import '../../../core/fpl_api.dart';
import '../models/gameweek.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FplRepository {
  FplRepository(this._dio);
  final Dio _dio;

  Future<DateTime?> fetchNextDeadlineUtc() async {
    try {
      final res = await _dio.get(kFplBootstrapUrl);
      final events = (res.data['events'] as List).cast<Map<String, dynamic>>();
      Map<String, dynamic>? next =
      events.firstWhere((e) => (e['is_next'] as bool?) == true, orElse: () => {});
      if (next.isEmpty) {
        final now = DateTime.now().toUtc();
        next = events.firstWhere(
              (e) => DateTime.parse(e['deadline_time'] as String).toUtc().isAfter(now),
          orElse: () => {},
        );
        if (next.isEmpty) return null;
      }
      return Gameweek.fromJson(next).deadlineUtc;
    } catch (_) {
      if (kIsWeb) return DateTime.now().toUtc().add(const Duration(hours: 72));
      rethrow;
    }
  }
}