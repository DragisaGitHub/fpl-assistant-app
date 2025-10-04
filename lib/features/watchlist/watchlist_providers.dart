import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateNotifierProvider u v3
import '../players/providers/players_providers.dart';
import '../players/models/player_vm.dart';
import 'watchlist_repository.dart';

final watchlistRepoProvider = Provider<WatchlistRepository>((ref) => WatchlistRepository());

class WatchlistController extends StateNotifier<Set<int>> {
  WatchlistController(this._repo) : super(<int>{}) { _init(); }
  final WatchlistRepository _repo;

  Future<void> _init() async {
    state = await _repo.load();
  }

  Future<void> toggle(int id) async {
    final s = {...state};
    if (!s.remove(id)) s.add(id);
    state = s;
    await _repo.save(state);
  }

  bool isWatched(int id) => state.contains(id);
}

final watchlistIdsProvider =
StateNotifierProvider<WatchlistController, Set<int>>(
      (ref) => WatchlistController(ref.watch(watchlistRepoProvider)),
);

final watchlistedPlayersProvider = Provider<AsyncValue<List<PlayerVm>>>((ref) {
  final all = ref.watch(playersProvider);
  final ids = ref.watch(watchlistIdsProvider);
  return all.whenData((list) => list.where((p) => ids.contains(p.id)).toList());
});