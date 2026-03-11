import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class DetailsInfoChip extends StatelessWidget {
  final double height;
  final String iconPath;
  final String title;

  const DetailsInfoChip({
    super.key,

    this.height = 48,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24, child: Image.asset(iconPath)),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
