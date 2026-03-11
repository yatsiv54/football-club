import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class TrainingInfoWidget extends StatelessWidget {
  final String icon;
  final String title;
  const TrainingInfoWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(8),
      ),

      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(
          spacing: 8,
          children: [
            Image.asset(icon),
            Text(
              overflow: TextOverflow.ellipsis,
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
