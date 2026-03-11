import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';

class StatusChip extends StatelessWidget {
  final MatchStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: status == MatchStatus.upcoming
            ? MyColors.myYellowColor.withValues(alpha: 0.16)
            : MyColors.myGreen.withValues(alpha: 0.16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            status == MatchStatus.upcoming ? 'Upcoming' : 'Finished',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: status == MatchStatus.upcoming
                  ? MyColors.myYellowColor
                  : Color.fromRGBO(69, 202, 18, 1),
            ),
          ),
        ),
      ),
    );
  }
}
