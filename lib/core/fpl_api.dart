import 'package:dio/dio.dart';

const kFplBootstrapUrl = 'https://fantasy.premierleague.com/api/bootstrap-static/';

Dio buildDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'User-Agent': 'FPL Assistant Lite (dev)',
      },
    ),
  );
}