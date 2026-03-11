import 'package:fortuna/core/db/drift/drift_database.dart';
import 'package:fortuna/features/objectives/data/objectives_repository.dart';
import 'package:fortuna/features/diary/data/diary_repository.dart';
import 'package:fortuna/features/matches/data/repositories/matches_repository.dart';
import 'package:fortuna/features/squad/data/players_repository.dart';
import 'package:fortuna/features/trainings/data/trainings_repository.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

Future<void> initDependencies() async {
  getit.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getit.registerLazySingleton<MatchesRepository>(
    () => MatchesRepository(getit<AppDatabase>()),
  );
  getit.registerLazySingleton<TrainingsRepository>(
    () => TrainingsRepository(getit<AppDatabase>()),
  );
  getit.registerLazySingleton<PlayersRepository>(
    () => PlayersRepository(getit<AppDatabase>()),
  );
  getit.registerLazySingleton<DiaryRepository>(
    () => DiaryRepository(getit<AppDatabase>()),
  );
  getit.registerLazySingleton<ObjectivesRepository>(
    () => ObjectivesRepository(getit<AppDatabase>()),
  );
}
