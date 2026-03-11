import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';

class ScoreChip extends StatelessWidget {
  final String scoreText;
  const ScoreChip({super.key, required this.scoreText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 48,
      decoration: BoxDecoration(
        color: MyColors.grey3,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                formatScore2(scoreText),
                style: Theme.of(context).textTheme.displayLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
