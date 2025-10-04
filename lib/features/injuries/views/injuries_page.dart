import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/tokens.dart';
import '../../players/models/player_vm.dart';
import '../providers/injuries_providers.dart';

class InjuriesPage extends ConsumerWidget {
  const InjuriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(injuriesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Injuries & Suspensions')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search name or team...',
                    ),
                    onChanged: (v) =>
                    ref.read(injuriesSearchQueryProvider.notifier).state = v,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Row(
                  children: [
                    const Text('Doubtful only'),
                    const SizedBox(width: AppSpacing.xs),
                    Switch(
                      value: ref.watch(doubtfulOnlyProvider),
                      onChanged: (v) => ref
                          .read(doubtfulOnlyProvider.notifier)
                          .state = v,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
                data: (list) => list.isEmpty
                    ? const _Empty()
                    : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (ctx, i) => _PlayerInjuryTile(p: list[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('No injuries/suspensions to show.'));
}

class _PlayerInjuryTile extends StatelessWidget {
  const _PlayerInjuryTile({required this.p});
  final PlayerVm p;

  String _statusText() {
    final ch = p.chance;
    if (ch == 0) return 'Out';
    if (ch != null && ch < 100) return 'Doubtful ($ch%)';
    if (p.status != 'a') return p.status.toUpperCase();
    return 'Available';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor =
    p.chance == 0 || p.status == 'i' ? scheme.error :
    (p.chance != null && p.chance! < 100) ? scheme.tertiary : scheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: badgeColor.withOpacity(.1),
              foregroundColor: badgeColor,
              child: const Icon(Icons.healing),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${p.name} • ${p.team}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    _statusText(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Form ${p.form.toStringAsFixed(1)} • Price ${p.price.toStringAsFixed(1)}m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}