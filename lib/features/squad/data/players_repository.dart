import 'package:drift/drift.dart';
import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';

class PlayersRepository {
  final AppDatabase db;

  PlayersRepository(this.db);

  Stream<List<PlayerEntity>> watchPlayers() {
    return (db.select(db.players)
          ..orderBy([
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapRowToEntity).toList());
  }
    Stream<PlayerEntity?> watchPlayer(int id) {
    final query = db.select(db.players)..where((tbl) => tbl.id.equals(id));
    return query.watchSingleOrNull().map(
          (row) => row != null ? _mapRowToEntity(row) : null,
        );
  }

  Future<PlayerEntity?> getPlayerById(int id) async {
    final query = db.select(db.players)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToEntity(row) : null;
  }

  Future<int> addPlayer({
    required String name,
    required String position,
    int? jerseyNumber,
    DateTime? dob,
    String phoneNumber = '',
    String email = '',
    String note = '',
  }) {
    return db.into(db.players).insert(
          PlayersCompanion.insert(
            name: name,
            position: position,
            jerseyNumber: Value(jerseyNumber),
            dob: Value(dob),
            phoneNumber: Value(phoneNumber),
            email: Value(email),
            note: Value(note),
          ),
        );
  }

  Future<int> updatePlayer({
    required int id,
    required String name,
    required String position,
    int? jerseyNumber,
    DateTime? dob,
    String phoneNumber = '',
    String email = '',
    String note = '',
  }) {
    return (db.update(db.players)..where((tbl) => tbl.id.equals(id))).write(
      PlayersCompanion(
        name: Value(name),
        position: Value(position),
        jerseyNumber: Value(jerseyNumber),
        dob: Value(dob),
        phoneNumber: Value(phoneNumber),
        email: Value(email),
        note: Value(note),
      ),
    );
  }

  Future<int> deletePlayer(int id) {
    return (db.delete(db.players)..where((tbl) => tbl.id.equals(id))).go();
  }

  PlayerEntity _mapRowToEntity(Player row) {
    return PlayerEntity(
      id: row.id,
      name: row.name,
      position: row.position,
      jerseyNumber: row.jerseyNumber,
      dob: row.dob,
      phoneNumber: row.phoneNumber,
      email: row.email,
      note: row.note,
    );
  }
}
