import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/tokens.dart';
import 'auth_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});
  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = _ctrl.text.trim();
      if (raw.isEmpty) throw 'Please enter your Entry ID.';
      final id = int.parse(raw);

      await ref.read(entryIdProvider.notifier).setEntryId(id);

      if (mounted) {
        context.go('/my-team');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Let’s connect your FPL team',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'FPL Entry ID',
                hintText: 'e.g. 1234567',
                prefixIcon: Icon(Icons.numbers),
              ),
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _loading ? null : _submit,
              icon: _loading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.login),
              label: const Text('Continue'),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Tip: Entry ID is the number in the URL of your team page on the official Fantasy Premier League website.',
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock),
              label: const Text('Full sign-in (coming soon)'),
            ),
          ],
        ),
      ),
    );
  }
}