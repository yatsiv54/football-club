import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';

class PlayerCard extends StatelessWidget {
  final PlayerEntity player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.grey3,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24,
                    child: Image.asset('assets/images/squad/player.png'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      player.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PositionChip(position: player.position),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyColors.grey3,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Text(
                      'Jersey Number',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Spacer(),
                    Text(
                      player.jerseyNumber != null
                          ? '#${player.jerseyNumber}'
                          : '-',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PositionChip extends StatelessWidget {
  final String position;
  const PositionChip({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: MyColors.myYellowColor, width: 1.2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          overflow: TextOverflow.ellipsis,
          position.toUpperCase(),
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
