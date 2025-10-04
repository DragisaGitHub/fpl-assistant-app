import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../deadlines/widgets/deadline_countdown.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FPL Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DeadlineCountdown(),
            const SizedBox(height: 8),
            const Text('Welcome 👋', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/players'),
                  icon: const Icon(Icons.people_outline),
                  label: const Text('Players'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/watchlist'),
                  icon: const Icon(Icons.star_border),
                  label: const Text('Watchlist'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}