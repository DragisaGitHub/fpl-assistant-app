import 'package:dio/dio.dart';

class MyTeamRepository {
  MyTeamRepository(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> fetchEntry(int entryId) async {
    final r = await _dio.get('https://fantasy.premierleague.com/api/entry/$entryId/');
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchPicks({required int entryId, required int eventId}) async {
    final r = await _dio.get('https://fantasy.premierleague.com/api/entry/$entryId/event/$eventId/picks/');
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchBootstrap() async {
    final r = await _dio.get('https://fantasy.premierleague.com/api/bootstrap-static/');
    return r.data as Map<String, dynamic>;
  }
}