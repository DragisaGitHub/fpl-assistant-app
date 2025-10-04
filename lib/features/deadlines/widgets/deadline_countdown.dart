import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/deadline_providers.dart';

class DeadlineCountdown extends ConsumerWidget {
  const DeadlineCountdown({super.key});

  String _fmt(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final mins = d.inMinutes % 60;
    final secs = d.inSeconds % 60;
    return '${days}d ${hours}h ${mins}m ${secs}s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextDeadline = ref.watch(nextDeadlineProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: nextDeadline.when(
          loading: () => const Row(
            children: [CircularProgressIndicator(), SizedBox(width: 12), Text('Loading next deadline...')],
          ),
          error: (e, _) => Text('Failed to load deadline: $e'),
          data: (utc) {
            if (utc == null) return const Text('No upcoming deadline found');
            final local = utc.toLocal();
            final countdown = ref.watch(countdownProvider(utc));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next deadline (local): ${local.toString().substring(0, 16)}'),
                const SizedBox(height: 8),
                countdown.when(
                  loading: () => const Text('Starting timer...'),
                  error: (e, _) => Text('Timer error: $e'),
                  data: (d) => Text(
                    d.isNegative ? 'Deadline passed' : _fmt(d),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}