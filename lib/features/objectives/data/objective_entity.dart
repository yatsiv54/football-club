enum ObjectiveStatus { active, completed, archived }

enum ObjectiveCategory {
  fitness,
  training,
  performance,
  recovery,
  mindset,
  teamwork,
  seasonGoal,
}

enum GoalType { simple, stepBased }

class ObjectiveEntity {
  final int id;
  final String title;
  final ObjectiveStatus status;
  final ObjectiveCategory category;
  final String description;
  final DateTime? deadline;
  final GoalType goalType;
  final Map<String, bool> steps;

  ObjectiveEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.category,
    required this.description,
    required this.deadline,
    required this.goalType,
    required this.steps,
  });
}
