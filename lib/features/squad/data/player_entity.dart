class PlayerEntity {
  final int id;
  final String name;
  final String position;
  final int? jerseyNumber;
  final DateTime? dob;
  final String phoneNumber;
  final String email;
  final String note;

  PlayerEntity({
    required this.id,
    required this.name,
    required this.position,
    this.jerseyNumber,
    this.dob,
    required this.phoneNumber,
    required this.email,
    required this.note,
  });
}
