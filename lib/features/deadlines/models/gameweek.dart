class Gameweek {
  final int id;
  final DateTime deadlineUtc;
  final bool isNext;
  final bool isCurrent;

  Gameweek({
    required this.id,
    required this.deadlineUtc,
    required this.isNext,
    required this.isCurrent,
  });

  factory Gameweek.fromJson(Map<String, dynamic> j) => Gameweek(
    id: j['id'] as int,
    deadlineUtc: DateTime.parse(j['deadline_time'] as String).toUtc(),
    isNext: j['is_next'] as bool? ?? false,
    isCurrent: j['is_current'] as bool? ?? false,
  );
}