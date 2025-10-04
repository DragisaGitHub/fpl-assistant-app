import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/di.dart';
import '../data/players_repository.dart';
import '../models/player_vm.dart';

final playersRepoProvider =
Provider<PlayersRepository>((ref) => PlayersRepository(ref.watch(dioProvider)));

final playersProvider =
FutureProvider<List<PlayerVm>>((ref) => ref.watch(playersRepoProvider).fetchPlayers());

final searchQueryProvider    = StateProvider<String>((ref) => '');
final positionFilterProvider = StateProvider<String?>((ref) => null);
final availableOnlyProvider  = StateProvider<bool>((ref) => false);

final filteredPlayersProvider = Provider<AsyncValue<List<PlayerVm>>>((ref) {
  final players = ref.watch(playersProvider);
  final q = ref.watch(searchQueryProvider);
  final pos = ref.watch(positionFilterProvider);
  final onlyAvail = ref.watch(availableOnlyProvider);

  return players.whenData((list) {
    Iterable<PlayerVm> it = list;
    if (q.isNotEmpty) {
      final lq = q.toLowerCase();
      it = it.where((p) => p.name.toLowerCase().contains(lq) || p.team.toLowerCase().contains(lq));
    }
    if (pos != null) it = it.where((p) => p.position == pos);
    if (onlyAvail) {
      it = it.where((p) {
        final okStatus = p.status == 'a';
        final okChance = p.chance == null || p.chance! >= 50;
        return okStatus && okChance;
      });
    }
    final sorted = it.toList()..sort((a, b) => b.form.compareTo(a.form));
    return sorted;
  });
});