import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../players/models/player_vm.dart';
import 'watchlist_providers.dart';

class WatchlistPage extends ConsumerWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(watchlistedPlayersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (list) => list.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Your watchlist is empty.'),
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: () => context.push('/players'),
                  icon: const Icon(Icons.search),
                  label: const Text('Add players'),
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.xs),
            itemBuilder: (ctx, i) => _PlayerTile(p: list[i]),
          ),
        ),
      ),
    );
  }
}

class _PlayerTile extends ConsumerWidget {
  const _PlayerTile({required this.p});
  final PlayerVm p;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watched = ref.watch(watchlistIdsProvider).contains(p.id);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text('${p.name} • ${p.team}'),
        subtitle: Text(
          'Form ${p.form.toStringAsFixed(1)} • ${p.position} • ${p.price.toStringAsFixed(1)}m',
        ),
        trailing: IconButton(
          icon: Icon(watched ? Icons.star : Icons.star_border),
          onPressed: () =>
              ref.read(watchlistIdsProvider.notifier).toggle(p.id),
        ),
      ),
    );
  }
}