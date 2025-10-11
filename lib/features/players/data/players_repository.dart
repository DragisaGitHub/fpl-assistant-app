import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../players/models/player_vm.dart';

class PlayersRepository {
  PlayersRepository(this._dio);
  final Dio _dio;

  static const _api = 'https://fantasy.premierleague.com/api/bootstrap-static/';

  Future<List<PlayerVm>> fetchPlayers() async {
    try {
      final res = await _dio.get(_api,
          options: Options(responseType: ResponseType.json));
      return _mapResponse(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final isLikelyCors = kIsWeb &&
          (e.type == DioExceptionType.unknown ||
              e.type == DioExceptionType.badResponse ||
              e.error?.toString().contains('XMLHttpRequest') == true);

      if (isLikelyCors) {
        final sample = await _loadSample();
        return _mapResponse(sample);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadSample() async {
    const sampleJson = '''
    {
      "teams":[
        {"id":1,"name":"Arsenal"},
        {"id":2,"name":"Aston Villa"}
      ],
      "elements":[
        {
          "id": 1,
          "first_name": "Aaron",
          "second_name": "Ramsdale",
          "web_name": "Ramsdale",
          "team": 1,
          "element_type": 1,
          "now_cost": 50,
          "form": "3.2",
          "status": "a",
          "chance_of_playing_next_round": 100
        },
        {
          "id": 2,
          "first_name": "Ollie",
          "second_name": "Watkins",
          "web_name": "Watkins",
          "team": 2,
          "element_type": 4,
          "now_cost": 82,
          "form": "7.1",
          "status": "a",
          "chance_of_playing_next_round": 75
        }
      ]
    }
    ''';
    return json.decode(sampleJson) as Map<String, dynamic>;
  }

  List<PlayerVm> _mapResponse(Map<String, dynamic> json) {
    final teams = (json['teams'] as List)
        .cast<Map<String, dynamic>>()
        .fold<Map<int, String>>({}, (acc, t) {
      acc[t['id'] as int] = t['name'] as String;
      return acc;
    });

    String posName(int t) {
      switch (t) {
        case 1:
          return 'GK';
        case 2:
          return 'DEF';
        case 3:
          return 'MID';
        case 4:
          return 'FWD';
        default:
          return 'UNK';
      }
    }

    final elems = (json['elements'] as List).cast<Map<String, dynamic>>();
    return elems.map((e) {
      final id = e['id'] as int;
      final first = (e['first_name'] ?? '') as String;
      final second = (e['second_name'] ?? '') as String;
      final webName = (e['web_name'] ?? '') as String;
      final name = (('$first $second').trim().isEmpty ? webName : '$first $second').trim();

      final teamId = e['team'] as int;
      final team = teams[teamId] ?? 'Team $teamId';

      final elementType = e['element_type'] as int; // 1..4
      final position = posName(elementType);

      final nowCost = (e['now_cost'] as num?) ?? 0; // pence → mil.
      final price = nowCost / 10.0;

      final formStr = (e['form'] ?? '0') as String;
      final form = double.tryParse(formStr) ?? 0.0;

      final status = (e['status'] ?? 'a') as String; // a/d/i/s
      final chance = (e['chance_of_playing_next_round'] as num?)?.toInt();

      return PlayerVm(
        id: id,
        name: name,
        team: team,
        position: position,
        price: price.toDouble(),
        form: form,
        status: status,
        chance: chance,
      );
    }).toList();
  }
}