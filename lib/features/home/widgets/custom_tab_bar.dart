import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/matches/presentation/widgets/match_card.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';

class ScheduleTabs extends StatelessWidget {
  const ScheduleTabs({super.key, required this.matches});

  final List<MatchEntity> matches;

  @override
  Widget build(BuildContext context) {
    final upcoming = matches
        .where((m) => m.status == MatchStatus.upcoming)
        .toList(growable: false);
    final past = matches
        .where((m) => m.status == MatchStatus.finished)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: MyColors.myBackgroundColor),
            child: TabBar(
              dividerColor: MyColors.grey2,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: MyColors.myYellowColor,
              indicatorWeight: 2,
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
              labelColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
          ),
          SizedBox(height: 6),
          Expanded(
            child: TabBarView(
              children: [
                _MatchList(
                  matches: upcoming,
                  emptyLabel: 'No upcoming matches',
                ),
                _MatchList(matches: past, emptyLabel: 'No past matches'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchList extends StatelessWidget {
  const _MatchList({required this.matches, required this.emptyLabel});

  final List<MatchEntity> matches;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        final match = matches[index];
        return MatchCard(match: match);
      },
      separatorBuilder: (context, _) => const SizedBox(height: 12),
      itemCount: matches.length,
    );
  }
}
