class MyTeamVm {
  final int gameweek;
  final List<PickVm> picks;

  MyTeamVm({required this.gameweek, required this.picks});
}

class PickVm {
  final int elementId;
  final String name;
  final String team;
  final String position;
  final int? multiplier;
  final bool isCaptain;
  final bool isVice;

  PickVm({
    required this.elementId,
    required this.name,
    required this.team,
    required this.position,
    required this.multiplier,
    required this.isCaptain,
    required this.isVice,
  });
}