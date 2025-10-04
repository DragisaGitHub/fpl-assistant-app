import 'package:dio/dio.dart';
import 'fpl_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => buildDio());