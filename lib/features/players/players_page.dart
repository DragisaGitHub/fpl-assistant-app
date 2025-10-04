import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/players_providers.dart';

class PlayersPage extends ConsumerWidget {
  const PlayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredPlayersProvider);
    final pos = ref.watch(positionFilterProvider);
    final avail = ref.watch(availableOnlyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search name or team...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String?>(
                  value: pos,
                  hint: const Text('Pos'),
                  onChanged: (v) => ref.read(positionFilterProvider.notifier).state = v,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'GK', child: Text('GK')),
                    DropdownMenuItem(value: 'DEF', child: Text('DEF')),
                    DropdownMenuItem(value: 'MID', child: Text('MID')),
                    DropdownMenuItem(value: 'FWD', child: Text('FWD')),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Text('Available'),
                    Switch(
                      value: avail,
                      onChanged: (v) => ref.read(availableOnlyProvider.notifier).state = v,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load players'
                        '${e.toString().contains("XMLHttpRequest") ? " (CORS on web)" : ""}',
                  ),
                ),
                data: (players) {
                  if (players.isEmpty) return const Center(child: Text('No players to show.'));
                  return ListView.separated(
                    itemCount: players.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final p = players[i];
                      return ListTile(
                        dense: true,
                        title: Text('${p.name} • ${p.team}'),
                        subtitle: Text('${p.position} • £${p.price.toStringAsFixed(1)} • form ${p.form.toStringAsFixed(1)}'),
                        trailing: _availabilityChip(p.status, p.chance),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availabilityChip(String status, int? chance) {
    switch (status) {
      case 'a':
        return Chip(label: Text('Fit ${chance == null ? "" : "(${chance}%)"}'));
      case 'i':
        return const Chip(label: Text('Injured'));
      case 'd':
        return Chip(label: Text('Doubtful ${chance == null ? "" : "(${chance}%)"}'));
      case 's':
        return const Chip(label: Text('Suspended'));
      default:
        return const Chip(label: Text('Unknown'));
    }
  }
}