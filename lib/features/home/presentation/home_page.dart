import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_fab.dart';
import 'package:fortuna/features/home/widgets/custom_tab_bar.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/layout/widgets/stat_button.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';
import 'package:fortuna/features/matches/data/repositories/matches_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MatchesRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = getit<MatchesRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'SCHEDULE', action: StatButton()),

      body: StreamBuilder<List<MatchEntity>>(
        stream: _repository.watchMatches(),
        builder: (context, snapshot) {
          final matches = snapshot.data ?? const <MatchEntity>[];
          return ScheduleTabs(matches: matches);
        },
      ),
      floatingActionButton: CustomFab(type: ButtonType.matches),
    );
  }
}
