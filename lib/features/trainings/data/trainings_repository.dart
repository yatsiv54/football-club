import 'package:drift/drift.dart';
import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';

class TrainingsRepository {
  final AppDatabase db;

  TrainingsRepository(this.db);

  Stream<List<TrainingEntity>> watchTrainings() {
    return (db.select(db.trainings)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                )
          ]))
        .watch()
        .map((rows) => rows.map(_mapRowToEntity).toList());
  }

  Future<TrainingEntity?> getTrainingById(int id) async {
    final query = db.select(db.trainings)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToEntity(row) : null;
  }

  Stream<TrainingEntity?> watchTraining(int id) {
    final query = db.select(db.trainings)..where((tbl) => tbl.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row != null ? _mapRowToEntity(row) : null,
    );
  }

  Future<int> addTraining({
    required String title,
    String notes = '',
    required DateTime date,
    required int durationMinutes,
  }) {
    return db
        .into(db.trainings)
        .insert(
          TrainingsCompanion.insert(
            title: title,
            notes: Value(notes),
            date: date,
            durationMinutes: durationMinutes,
          ),
        );
  }

  Future<int> updateTraining({
    required int id,
    required String title,
    String notes = '',
    required DateTime date,
    required int durationMinutes,
  }) {
    return (db.update(db.trainings)..where((tbl) => tbl.id.equals(id))).write(
      TrainingsCompanion(
        title: Value(title),
        notes: Value(notes),
        date: Value(date),
        durationMinutes: Value(durationMinutes),
      ),
    );
  }

  Future<int> deleteTraining(int id) {
    return (db.delete(db.trainings)..where((tbl) => tbl.id.equals(id))).go();
  }

  TrainingEntity _mapRowToEntity(Training row) {
    return TrainingEntity(
      id: row.id,
      title: row.title,
      notes: row.notes,
      date: row.date,
      durationMinutes: row.durationMinutes,
    );
  }
}
