import 'package:flutter/material.dart';
import 'package:fortuna/features/diary/presentation/diary_page.dart';
import 'package:fortuna/features/diary/presentation/diaty_details_page.dart';
import 'package:fortuna/features/home/presentation/add_matches_page.dart';
import 'package:fortuna/features/home/presentation/home_page.dart';
import 'package:fortuna/features/layout/layout_scaffold.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';
import 'package:fortuna/features/matches/presentation/match_details_page.dart';
import 'package:fortuna/features/objectives/presentation/add_objectives_page.dart';
import 'package:fortuna/features/objectives/presentation/objectives_page.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';
import 'package:fortuna/features/objectives/presentation/objective_details_page.dart';
import 'package:fortuna/features/splash/presentation/splash_page.dart';
import 'package:fortuna/features/splash/presentation/welcome_page.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';
import 'package:fortuna/features/squad/presentation/add_player_page.dart';
import 'package:fortuna/features/squad/presentation/player_details_page.dart';
import 'package:fortuna/features/squad/presentation/squad_page.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/presentation/add_diary_page.dart';
import 'package:fortuna/features/stat/presentation/stat_page.dart';
import 'package:fortuna/features/trainings/presentation/add_training_page.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:fortuna/features/trainings/presentation/training_details_page.dart';
import 'package:fortuna/features/trainings/presentation/training_page.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'homeBranchNavigator',
);
final GlobalKey<NavigatorState> _trainingNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'trainingBranchNavigator');

final GlobalKey<NavigatorState> _squadNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'squadBranchNavigator',
);
final GlobalKey<NavigatorState> _diaryNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'diarynavigatorkey',
);

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: SplashPage());
      },
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: WelcomePage());
      },
    ),
    GoRoute(
      path: '/home/addmatch',
      name: 'addmatch',
      pageBuilder: (context, state) {
        final match = state.extra is MatchEntity
            ? state.extra as MatchEntity
            : null;
        return NoTransitionPage(child: AddMatchesPage(initialMatch: match));
      },
    ),
    GoRoute(
      path: '/home/stat',
      name: 'stat',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: StatPage());
      },
    ),
    GoRoute(
      path: '/home/matchdetails',
      name: 'matchdetails',
      pageBuilder: (context, state) {
        final match = state.extra as MatchEntity;
        return NoTransitionPage(child: MatchDetailsPage(match: match));
      },
    ),
    GoRoute(
      path: '/squad/playerdetails',
      name: 'playerdetails',
      pageBuilder: (context, state) {
        final player = state.extra as PlayerEntity;
        return NoTransitionPage(child: PlayerDetailPage(player: player));
      },
    ),
    GoRoute(
      path: '/squad/addplayer',
      name: 'addplayer',
      pageBuilder: (context, state) {
        final player = state.extra is PlayerEntity
            ? state.extra as PlayerEntity
            : null;
        return NoTransitionPage(child: AddPlayerPage(initialPlayer: player));
      },
    ),
    GoRoute(
      path: '/training/addtraining',
      name: 'addtraining',
      pageBuilder: (context, state) {
        final training = state.extra is TrainingEntity
            ? state.extra as TrainingEntity
            : null;
        return NoTransitionPage(
          child: AddTrainingPage(initialTraining: training),
        );
      },
    ),
    GoRoute(
      path: '/training/trainingdetails',
      name: 'trainingdetails',
      pageBuilder: (context, state) {
        final training = state.extra as TrainingEntity;

        return NoTransitionPage(child: TrainingDetailsPage(training: training));
      },
    ),
    GoRoute(
      path: '/diary/adddiary',
      name: 'adddiary',
      pageBuilder: (context, state) {
        final diary = state.extra is DiaryEntity
            ? state.extra as DiaryEntity
            : null;
        return NoTransitionPage(child: AddDiaryPage(initialDiary: diary));
      },
    ),
    GoRoute(
      path: '/diary/diarydetails',
      name: 'diarydetails',
      pageBuilder: (context, state) {
        final diary = state.extra as DiaryEntity;

        return NoTransitionPage(child: DiaryDetailsPage(diary: diary));
      },
    ),
    GoRoute(
      path: '/objectives',
      name: 'objectives',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ObjectivesPage());
      },
    ),
    GoRoute(
      path: '/objectives/addobjective',
      name: 'objectives/addobjective',
      pageBuilder: (context, state) {
        final objective = state.extra is ObjectiveEntity
            ? state.extra as ObjectiveEntity
            : null;
        return NoTransitionPage(
          child: AddObjectivesPage(initialObjective: objective),
        );
      },
    ),
    GoRoute(
      path: '/objectives/details',
      name: 'objectives/details',
      pageBuilder: (context, state) {
        final objective = state.extra as ObjectiveEntity;
        return NoTransitionPage(
          child: ObjectiveDetailsPage(objective: objective),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) => LayoutScaffold(
        shell: navigationShell,
        showNavBar: _needNavbar(state),
      ),

      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              name: 'home', 
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _trainingNavigatorKey,
          routes: [
            GoRoute(
              path: '/training',
              name: 'training',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: TrainingPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _squadNavigatorKey,
          routes: [
            GoRoute(
              path: '/squad',
              name: 'squad',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: SquadPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _diaryNavigatorKey,
          routes: [
            GoRoute(
              path: '/diary',
              name: 'diary',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: DiaryPage()),
            ),
          ],
        ),
      ],
    ),
  ],
);

bool _needNavbar(GoRouterState state) {
  switch (state.fullPath) {
    case '/home':
      return true;
    default:
      return true;
  }
}
