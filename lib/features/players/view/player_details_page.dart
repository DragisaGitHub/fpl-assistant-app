import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../watchlist/watchlist_providers.dart';
import '../../../theme/tokens.dart';
import '../providers/players_providers.dart';

class PlayerDetailsPage extends ConsumerWidget {
  const PlayerDetailsPage({super.key, required this.playerId});
  final int playerId;

  Color _statusColor(BuildContext ctx, String status, int? chance) {
    final cs = Theme.of(ctx).colorScheme;
    if (status == 'i' || chance == 0) return cs.error;
    if (status == 'd' || (chance != null && chance < 100)) return cs.tertiary;
    return cs.primary;
  }

  String _statusText(String status, int? chance) {
    switch (status) {
      case 'a':
        return 'Fit ${chance == null ? "" : "($chance%)"}';
      case 'i':
        return 'Injured';
      case 'd':
        return 'Doubtful ${chance == null ? "" : "($chance%)"}';
      case 's':
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAv = ref.watch(playerByIdProvider(playerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Player details')),
      body: playerAv.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (p) {
          if (p == null) {
            return const Center(child: Text('Player not found.'));
          }

          final watched = ref.watch(watchlistIdsProvider).contains(p.id);
          final cs = Theme.of(context).colorScheme;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        p.name.isNotEmpty ? p.name[0] : '?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: cs.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text('${p.team} • ${p.position}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(_statusText(p.status, p.chance)),
                            backgroundColor: _statusColor(context, p.status, p.chance).withValues(alpha: 0.1),
                            labelStyle: TextStyle(color: _statusColor(context, p.status, p.chance)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: watched ? 'Remove from watchlist' : 'Add to watchlist',
                      icon: Icon(watched ? Icons.star : Icons.star_border),
                      onPressed: () => ref.read(watchlistIdsProvider.notifier).toggle(p.id),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Quick stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatTile(label: 'Price', value: '£${p.price.toStringAsFixed(1)}m'),
                        _DividerDot(),
                        _StatTile(label: 'Form', value: p.form.toStringAsFixed(1)),
                        _DividerDot(),
                        _StatTile(label: 'ID', value: p.id.toString()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                Text('Recent form (TBD)', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Chart / mini-cards coming soon'),
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('Upcoming fixtures (TBD)', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Next opponents…'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4, height: 4,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}