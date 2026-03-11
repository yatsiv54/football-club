import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';
import 'package:fortuna/features/matches/data/repositories/matches_repository.dart';

class TotalWidget extends StatefulWidget {
  const TotalWidget({super.key});

  @override
  State<TotalWidget> createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<TotalWidget> {
  late final MatchesRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<MatchesRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MatchEntity>>(
      stream: _repo.watchMatches(),
      builder: (context, snapshot) {
        final matches = snapshot.data ?? const <MatchEntity>[];
        final stats = _calculateStats(matches);
        final total = stats.wins + stats.draws + stats.loses;
        final winFlex = stats.wins == 0 ? 0 : stats.wins.clamp(1, 1000);
        final drawFlex = stats.draws == 0 ? 0 : stats.draws.clamp(1, 1000);
        final loseFlex = stats.loses == 0 ? 0 : stats.loses.clamp(1, 1000);

        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.grey2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.grey3,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            '$total',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (total > 0)
                  Row(
                    children: [
                      if (winFlex > 0)
                        Expanded(
                          flex: winFlex,
                          child: const _TotalColorChip(
                            type: TotalColorChipType.win,
                          ),
                        ),
                      if (drawFlex > 0)
                        Expanded(
                          flex: drawFlex,
                          child: const _TotalColorChip(
                            type: TotalColorChipType.draw,
                          ),
                        ),
                      if (loseFlex > 0)
                        Expanded(
                          flex: loseFlex,
                          child: const _TotalColorChip(
                            type: TotalColorChipType.lose,
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 6),
                _TotalLegend(stats: stats),
              ],
            ),
          ),
        );
      },
    );
  }

  _MatchStats _calculateStats(List<MatchEntity> matches) {
    int wins = 0;
    int draws = 0;
    int loses = 0;

    for (final match in matches) {
      if (match.status != MatchStatus.finished) continue;
      final parts = match.score.split(RegExp('[:\\-]'));
      if (parts.length != 2) continue;

      final home = int.tryParse(parts[0].trim());
      final away = int.tryParse(parts[1].trim());
      if (home == null || away == null) continue;

      if (home > away) {
        wins++;
      } else if (home < away) {
        loses++;
      } else {
        draws++;
      }
    }

    return _MatchStats(wins: wins, draws: draws, loses: loses);
  }
}

class _MatchStats {
  final int wins;
  final int draws;
  final int loses;

  const _MatchStats({
    required this.wins,
    required this.draws,
    required this.loses,
  });
}

class _TotalColorChip extends StatelessWidget {
  final TotalColorChipType type;
  const _TotalColorChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: type == TotalColorChipType.win
            ? Color.fromRGBO(69, 202, 18, 1)
            : type == TotalColorChipType.lose
            ? Color.fromRGBO(230, 0, 0, 1)
            : MyColors.myYellowColor,
      ),
    );
  }
}

enum TotalColorChipType { win, draw, lose }

class _TotalLegend extends StatelessWidget {
  final _MatchStats stats;
  const _TotalLegend({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: Color.fromRGBO(69, 202, 18, 1), size: 16),
        Text(' ${stats.wins}', style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis,),
        Text(' Wins', style: Theme.of(context).textTheme.bodyLarge,overflow: TextOverflow.ellipsis,),
        SizedBox(width: 12),
        Icon(Icons.circle, color: MyColors.myYellowColor, size: 16),
        Text(' ${stats.draws}', style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis,),
        Text(' Draws', style: Theme.of(context).textTheme.bodyLarge,overflow: TextOverflow.ellipsis,),
        SizedBox(width: 12),
        Icon(Icons.circle, color: Color.fromRGBO(230, 0, 0, 1), size: 16),
        Text(' ${stats.loses}', style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis,),
        Text(' Loses', style: Theme.of(context).textTheme.bodyLarge,overflow: TextOverflow.ellipsis,),
      ],
    );
  }
}
