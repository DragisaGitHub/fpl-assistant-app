import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Dio buildDio() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'fpl-assistant-lite/1.0',
    },
  ),
);

final dioProvider = Provider<Dio>((ref) => buildDio());