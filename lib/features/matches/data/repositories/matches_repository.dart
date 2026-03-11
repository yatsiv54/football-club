import 'package:drift/drift.dart';
import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';

class MatchesRepository {
  final AppDatabase db;

  MatchesRepository(this.db);

  Stream<List<MatchEntity>> watchMatches() {
    return (db.select(db.matches)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date),
          ]))
        .watch()
        .map((rows) => rows.map(_mapRowToEntity).toList());
  }

  Stream<MatchEntity?> watchMatch(int id) {
    final query = db.select(db.matches)..where((tbl) => tbl.id.equals(id));
    return query.watchSingleOrNull().map(
          (row) => row != null ? _mapRowToEntity(row) : null,
        );
  }

  Future<MatchEntity?> getMatchById(int id) async {
    final query = db.select(db.matches)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToEntity(row) : null;
  }

  Future<int> addMatch({
    required String opponent,
    required String place,
    required DateTime dateTime,
    MatchStatus status = MatchStatus.upcoming,
    String notes = '',
    String score = '',
  }) {
    return db.into(db.matches).insert(
          MatchesCompanion.insert(
            opponent: opponent,
            place: place,
            date: dateTime,
            completed: Value(status == MatchStatus.finished),
            score: Value(score),
            notes: notes,
          ),
        );
  }

  Future<int> updateMatch({
    required int id,
    required String opponent,
    required String place,
    required DateTime dateTime,
    required MatchStatus status,
    String score = '',
    String notes = '',
  }) {
    return (db.update(db.matches)..where((tbl) => tbl.id.equals(id))).write(
      MatchesCompanion(
        opponent: Value(opponent),
        place: Value(place),
        date: Value(dateTime),
        completed: Value(status == MatchStatus.finished),
        score: Value(score),
        notes: Value(notes),
      ),
    );
  }

  Future<int> deleteMatch(int id) {
    return (db.delete(db.matches)..where((tbl) => tbl.id.equals(id))).go();
  }

  MatchEntity _mapRowToEntity(Matche row) {
    return MatchEntity(
      id: row.id,
      opponent: row.opponent,
      dateTime: row.date,
      location: row.place,
      status: row.completed ? MatchStatus.finished : MatchStatus.upcoming,
      notes: row.notes,
      score: row.score,
    );
  }
}
