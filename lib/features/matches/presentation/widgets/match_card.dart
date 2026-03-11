import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';
import 'package:fortuna/features/matches/presentation/widgets/location_chip.dart';
import 'package:fortuna/features/matches/presentation/widgets/score_chip.dart';
import 'package:fortuna/features/matches/presentation/widgets/status_chip.dart';
import 'package:go_router/go_router.dart';

class MatchCard extends StatelessWidget {
  final MatchEntity match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isFinished = match.status == MatchStatus.finished;
    final String dateText = formatDate(match.dateTime, '—');

    return GestureDetector(
      onTap: () => context.pushNamed('matchdetails', extra: match),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.grey2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: MyColors.grey3,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Image.asset('assets/images/home/soccer.png'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        match.opponent.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    StatusChip(status: match.status),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateText,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  isFinished
                      ? Row(
                          children: [
                            Expanded(
                              child: LocationChip(
                                location: match.location,
                                expanded: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: ScoreChip(scoreText: match.score)),
                          ],
                        )
                      : Row(
                          children: [
                            LocationChip(
                              location: match.location,
                              expanded: false,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
