import 'package:dio/dio.dart';
import '../../../core/fpl_api.dart';
import '../models/player_vm.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlayersRepository {
  PlayersRepository(this._dio);
  final Dio _dio;

  Future<List<PlayerVm>> fetchPlayers() async {
    try {
      final res = await _dio.get(kFplBootstrapUrl);
      final data = res.data as Map<String, dynamic>;

      final teamsList = (data['teams'] as List).cast<Map<String, dynamic>>();
      final teamShort = <int, String>{
        for (final t in teamsList) t['id'] as int: (t['short_name'] as String)
      };

      const posMap = {1: 'GK', 2: 'DEF', 3: 'MID', 4: 'FWD'};
      final elements = (data['elements'] as List).cast<Map<String, dynamic>>();

      return elements.map((e) {
        final first = (e['first_name'] as String?)?.trim() ?? '';
        final last  = (e['second_name'] as String?)?.trim() ?? '';
        final name  = ('$first $last').trim();

        final price = ((e['now_cost'] as num?) ?? 0).toDouble() / 10.0;
        final form  = double.tryParse((e['form'] as String?) ?? '0') ?? 0.0;
        final team  = teamShort[(e['team'] as int? ?? 0)] ?? '';
        final pos   = posMap[(e['element_type'] as int? ?? 0)] ?? '?';

        return PlayerVm(
          id: e['id'] as int,
          name: name,
          team: team,
          position: pos,
          price: price,
          form: form,
          status: (e['status'] as String?) ?? 'u',
          chance: e['chance_of_playing_next_round'] as int?,
        );
      }).toList();
    } catch (_) {
      if (kIsWeb) return const <PlayerVm>[];
      rethrow;
    }
  }
}