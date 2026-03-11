class MatchEntity {
  final int id;
  final String opponent;
  final DateTime dateTime;
  final String location;
  final MatchStatus status;
  final String notes;
  final String score;

  MatchEntity({
    required this.id,
    required this.opponent,
    required this.dateTime,
    required this.location,
    required this.status,
    required this.notes,
    required this.score,
  });
}

enum MatchStatus { upcoming, finished }
