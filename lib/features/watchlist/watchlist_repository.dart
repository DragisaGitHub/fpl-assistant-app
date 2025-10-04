import 'package:shared_preferences/shared_preferences.dart';

class WatchlistRepository {
  static const _key = 'watchlist_ids';

  Future<Set<int>> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? const <String>[];
    return raw.map(int.parse).toSet();
  }

  Future<void> save(Set<int> ids) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, ids.map((e) => e.toString()).toList());
  }
}