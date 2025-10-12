import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di.dart';
import '../auth/auth_providers.dart';
import 'my_team_repository.dart';
import 'my_team_vm.dart';

final myTeamRepoProvider = Provider<MyTeamRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MyTeamRepository(dio);
});

final myTeamProvider = FutureProvider<MyTeamVm?>((ref) async {
  final entryId = ref.watch(entryIdProvider);
  if (entryId == null) return null;

  final repo = ref.read(myTeamRepoProvider);

  final entry = await repo.fetchEntry(entryId);
  final gw = (entry['current_event'] ?? entry['summary_event']) as int?; // fallback
  if (gw == null) return null;

  final picksJson = await repo.fetchPicks(entryId: entryId, eventId: gw);
  final picks = (picksJson['picks'] as List).cast<Map<String, dynamic>>();

  final bootstrap = await repo.fetchBootstrap();
  final elements = (bootstrap['elements'] as List).cast<Map<String, dynamic>>();
  final teams = (bootstrap['teams'] as List).cast<Map<String, dynamic>>();
  final elementTypes = (bootstrap['element_types'] as List).cast<Map<String, dynamic>>();

  String teamName(int teamId) =>
      teams.firstWhere((t) => t['id'] == teamId)['name'] as String;

  String posName(int typeId) =>
      (elementTypes.firstWhere((e) => e['id'] == typeId)['singular_name_short'] as String);

  final mapped = picks.map((p) {
    final elId = p['element'] as int;
    final el = elements.firstWhere((e) => e['id'] == elId);
    final fullName = '${el['first_name']} ${el['second_name']}';
    final tName = teamName(el['team']);
    final pos = posName(el['element_type']);
    return PickVm(
      elementId: elId,
      name: fullName,
      team: tName,
      position: pos,
      multiplier: p['multiplier'] as int?,
      isCaptain: p['is_captain'] as bool? ?? false,
      isVice: p['is_vice_captain'] as bool? ?? false,
    );
  }).toList();

  return MyTeamVm(gameweek: gw, picks: mapped);
});