import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fortuna/core/db/drift/tables/drift_tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [Matches, Trainings, Players, Diaries, Objectives])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(matches, matches.score);
      }

      if (from < 3) {
        await migrator.createTable(trainings);
      }

      if (from < 4) {
        await migrator.createTable(players);
      }

      if (from < 5) {
        await migrator.createTable(diaries);
      } else if (from == 5) {
        await migrator.addColumn(diaries, diaries.date);
      }

      if (from < 8) {
        await customStatement(
          "UPDATE diaries "
          "SET date = CAST(strftime('%s', date) AS INTEGER) * 1000 "
          "WHERE typeof(date) = 'text'",
        );
        await customStatement(
          "UPDATE diaries "
          "SET date = CAST(strftime('%s', 'now') AS INTEGER) * 1000 "
          "WHERE date IS NULL",
        );
      }
      if (from < 9) {
        await migrator.createTable(objectives);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'match.db');
    return NativeDatabase(File(path));
  });
}
