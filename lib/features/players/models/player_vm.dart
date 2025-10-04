class PlayerVm {
  final int id;
  final String name;
  final String team;
  final String position;
  final double price;
  final double form;
  final String status;
  final int? chance;

  const PlayerVm({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.price,
    required this.form,
    required this.status,
    this.chance,
  });
}
