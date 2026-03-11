import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';

class ObjectivesRepository {
  final AppDatabase db;

  ObjectivesRepository(this.db);

  Stream<List<ObjectiveEntity>> watchObjectives() {
    return db.select(db.objectives).watch().map(
          (rows) => rows.map(_mapRowToEntity).toList(),
        );
  }

  Future<int> addObjective({
    required String title,
    required ObjectiveStatus status,
    required ObjectiveCategory category,
    String description = '',
    DateTime? deadline,
    required GoalType goalType,
    Map<String, bool> steps = const {},
  }) {
    return db.into(db.objectives).insert(
          ObjectivesCompanion.insert(
            title: title,
            status: status.index,
            category: category.index,
            description: Value(description),
            deadline: Value(deadline),
            goalType: goalType.index,
            stepsJson: Value(jsonEncode(steps)),
          ),
        );
  }

  Future<int> updateObjective({
    required int id,
    String? title,
    ObjectiveStatus? status,
    ObjectiveCategory? category,
    String? description,
    DateTime? deadline,
    GoalType? goalType,
    Map<String, bool>? steps,
  }) {
    return (db.update(db.objectives)..where((tbl) => tbl.id.equals(id))).write(
      ObjectivesCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        status: status != null ? Value(status.index) : const Value.absent(),
        category:
            category != null ? Value(category.index) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        deadline: Value(deadline),
        goalType: goalType != null ? Value(goalType.index) : const Value.absent(),
        stepsJson:
            steps != null ? Value(jsonEncode(steps)) : const Value.absent(),
      ),
    );
  }

  Future<int> deleteObjective(int id) {
    return (db.delete(db.objectives)..where((tbl) => tbl.id.equals(id))).go();
  }

  ObjectiveEntity _mapRowToEntity(Objective row) {
    Map<String, dynamic> decoded = {};
    try {
      decoded = jsonDecode(row.stepsJson) as Map<String, dynamic>;
    } catch (_) {}
    final steps = decoded.map((key, value) => MapEntry(key, value == true));

    return ObjectiveEntity(
      id: row.id,
      title: row.title,
      status: ObjectiveStatus.values[row.status],
      category: ObjectiveCategory.values[row.category],
      description: row.description,
      deadline: row.deadline,
      goalType: GoalType.values[row.goalType],
      steps: steps,
    );
  }
}
