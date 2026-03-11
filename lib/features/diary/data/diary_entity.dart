class DiaryEntity {
  final int id;
  final String title;
  final int mood;
  final String notes;
  final DateTime date;

  DiaryEntity({
    required this.id,
    required this.title,
    required this.mood,
    required this.notes,
    required this.date,
  });
}
