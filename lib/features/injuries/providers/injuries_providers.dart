import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // za StateProvider
import '../../players/providers/players_providers.dart';
import '../../players/models/player_vm.dart';

final injuriesSearchQueryProvider = StateProvider<String>((ref) => '');
final doubtfulOnlyProvider        = StateProvider<bool>((ref) => false);

bool _isInjuredOrSuspended(PlayerVm p) {
  final ch = p.chance ?? 100;
  return p.status != 'a' || ch < 100;
}

bool _isDoubtful(PlayerVm p) {
  final ch = p.chance;
  if (ch == null) return p.status != 'a';
  return ch < 100 && ch >= 1;
}

final injuriesListProvider = Provider<AsyncValue<List<PlayerVm>>>((ref) {
  final base = ref.watch(playersProvider);
  final q    = ref.watch(injuriesSearchQueryProvider);
  final onlyDoubtful = ref.watch(doubtfulOnlyProvider);

  return base.whenData((all) {
    Iterable<PlayerVm> it = all.where(_isInjuredOrSuspended);

    if (onlyDoubtful) {
      it = it.where(_isDoubtful);
    }

    final query = q.trim().toLowerCase();
    if (query.isNotEmpty) {
      it = it.where((p) =>
      p.name.toLowerCase().contains(query) ||
          p.team.toLowerCase().contains(query));
    }

    int rank(PlayerVm p) {
      final ch = p.chance ?? 100;
      if (p.status == 'i' || ch == 0) return 0;
      if (ch < 100) return 1;
      return 2;
    }

    final list = it.toList()
      ..sort((a, b) {
        final r = rank(a).compareTo(rank(b));
        if (r != 0) return r;
        return b.form.compareTo(a.form);
      });

    return list;
  });
});