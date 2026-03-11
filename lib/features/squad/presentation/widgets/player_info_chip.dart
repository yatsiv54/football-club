import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class PlayerInfoChip extends StatelessWidget {
  final String title;
  final String body;
  const PlayerInfoChip({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(overflow: TextOverflow.ellipsis,
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.white60),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            body),
        ],
      ),
    );
  }
}
