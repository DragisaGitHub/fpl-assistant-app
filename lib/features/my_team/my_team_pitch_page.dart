import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_providers.dart';
import 'my_team_providers.dart';
import 'my_team_vm.dart';

class MyTeamPage extends ConsumerWidget {
  const MyTeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryId = ref.watch(entryIdProvider);
    final team = ref.watch(myTeamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: team.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (vm) {
            if (entryId == null) {
              return const Center(child: Text('Go to Settings and enter your Entry ID.'));
            }
            if (vm == null) {
              return const Center(child: Text('No team data.'));
            }
            return _Pitch(vm: vm);
          },
        ),
      ),
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch({required this.vm});
  final MyTeamVm vm;

  @override
  Widget build(BuildContext context) {
    final starters = vm.picks.where((p) => (p.multiplier ?? 0) > 0).toList();
    final bench = vm.picks.where((p) => (p.multiplier ?? 0) == 0).toList();

    List<PickVm> gkp = starters.where((p) => p.position == 'GKP').toList();
    List<PickVm> def = starters.where((p) => p.position == 'DEF').toList();
    List<PickVm> mid = starters.where((p) => p.position == 'MID').toList();
    List<PickVm> fwd = starters.where((p) => p.position == 'FWD').toList();

    final formation = '${def.length}-${mid.length}-${fwd.length}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gameweek ${vm.gameweek} • $formation',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 9 / 16,
          child: LayoutBuilder(
            builder: (ctx, c) {
              return Container(
                decoration: _pitchDecoration(ctx),
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _PitchLinesPainter())),

                    // GKP (1 red)
                    _line(ctx, c, 0.12, gkp),

                    // DEF
                    _line(ctx, c, 0.30, def),

                    // MID
                    _line(ctx, c, 0.52, mid),

                    // FWD
                    _line(ctx, c, 0.75, fwd),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // BENCH
        Text('Bench', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Row(
          children: bench
              .map((p) => Expanded(child: _PlayerChip(p: p, small: true)))
              .toList(),
        ),
      ],
    );
  }

  Widget _line(BuildContext ctx, BoxConstraints c, double yFrac, List<PickVm> players) {
    if (players.isEmpty) return const SizedBox.shrink();
    final spacing = c.maxWidth / (players.length + 1);

    return Positioned.fill(
      child: Stack(
        children: List.generate(players.length, (i) {
          final x = spacing * (i + 1) - 44;
          final y = c.maxHeight * yFrac - 32;
          return Positioned(left: x, top: y, child: _PlayerChip(p: players[i]));
        }),
      ),
    );
  }

  BoxDecoration _pitchDecoration(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, .2, .2, .4, .4, .6, .6, .8, .8, 1.0],
        colors: [
          cs.tertiaryContainer.withOpacity(.35),
          cs.tertiaryContainer.withOpacity(.35),
          cs.tertiary.withOpacity(.25),
          cs.tertiary.withOpacity(.25),
          cs.tertiaryContainer.withOpacity(.35),
          cs.tertiaryContainer.withOpacity(.35),
          cs.tertiary.withOpacity(.25),
          cs.tertiary.withOpacity(.25),
          cs.tertiaryContainer.withOpacity(.35),
          cs.tertiaryContainer.withOpacity(.35),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({required this.p, this.small = false});
  final PickVm p;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final isC = p.isCaptain;
    final isV = p.isVice;
    final label = small ? _shortName(p.name) : p.name;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: small ? 18 : 24,
              child: Icon(_iconForPos(p.position), size: small ? 16 : 20),
            ),
            if (isC || isV)
              Positioned(
                right: -6,
                bottom: -6,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(isC ? 'C' : 'V', style: const TextStyle(fontSize: 12)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: small ? 11 : 12, fontWeight: FontWeight.w600),
        ),
        Text(
          p.team,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: small ? 10 : 11, color: Colors.black54),
        ),
        Text(
          p.position,
          style: TextStyle(fontSize: small ? 10 : 11, color: Colors.black45),
        ),
      ],
    );
  }

  String _shortName(String full) {
    final parts = full.split(' ');
    if (parts.length < 2) return full;
    final last = parts.last;
    final firstInitial = parts.first.characters.first;
    return '$firstInitial. $last';
  }

  IconData _iconForPos(String pos) {
    switch (pos) {
      case 'GKP':
        return Icons.sports_soccer;
      case 'DEF':
        return Icons.shield_moon_outlined;
      case 'MID':
        return Icons.casino_outlined;
      case 'FWD':
      default:
        return Icons.sports_handball_outlined;
    }
  }
}

class _PitchLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final r = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16));
    canvas.drawRRect(r, paint);

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawCircle(center, 34, paint);

    final boxH = size.height * 0.18;
    final boxW = size.width * 0.6;
    final x = (size.width - boxW) / 2;

    canvas.drawRect(Rect.fromLTWH(x, size.height - boxH - 8, boxW, boxH), paint);
    canvas.drawRect(Rect.fromLTWH(x, 8, boxW, boxH), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}