import 'package:drift/drift.dart';
import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:flutter/foundation.dart';

class DiaryRepository {
  final AppDatabase db;

  DiaryRepository(this.db);

  Stream<List<DiaryEntity>> watchDiaries() {
    return (db.select(db.diaries)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map(_mapRowToEntity).toList());
  }

  Future<DiaryEntity?> getDiaryById(int id) async {
    final query = db.select(db.diaries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToEntity(row) : null;
  }

  Stream<DiaryEntity?> watchDiary(int id) {
    final query = db.select(db.diaries)..where((tbl) => tbl.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row != null ? _mapRowToEntity(row) : null,
    );
  }

  Future<int> addDiary({
    required String title,
    required int mood,
    String notes = '',
  }) {
    return db
        .into(db.diaries)
        .insert(
          DiariesCompanion.insert(
            title: title,
            mood: mood,
            notes: Value(notes),
            date: Value(DateTime.now()),
          ),
        );
  }

  Future<int> updateDiary({
    required int id,
    required String title,
    required int mood,
    String notes = '',
  }) {
    return (db.update(db.diaries)..where((tbl) => tbl.id.equals(id))).write(
      DiariesCompanion(
        title: Value(title),
        mood: Value(mood),
        notes: Value(notes),
        date: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteDiary(int id) {
    return (db.delete(db.diaries)..where((tbl) => tbl.id.equals(id))).go();
  }

  DiaryEntity _mapRowToEntity(Diary row) {
    return DiaryEntity(
      id: row.id,
      title: row.title,
      mood: row.mood,
      notes: row.notes,
      date: row.date ?? DateTime.now(),
    );
  }

  Future<void> debugPrintDiaries() async {
    final rows = await db.select(db.diaries).get();
    final summary = rows
        .map(
          (d) =>
              'id=${d.id}, title=${d.title}, mood=${d.mood}, date=${d.date}, notes="${d.notes}"',
        )
        .join(' | ');
    debugPrint('DIARY DEBUG: count=${rows.length}; $summary');
  }
}
