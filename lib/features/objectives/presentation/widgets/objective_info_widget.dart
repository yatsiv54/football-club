import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class ObjectiveInfoWidget extends StatelessWidget {
  final String title;
  final String text;
  const ObjectiveInfoWidget({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey3,
        borderRadius: BorderRadius.circular(8),
      ),

      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(
          spacing: 8,
          children: [
            Text(overflow: TextOverflow.ellipsis,
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.white70),
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              text),
          ],
        ),
      ),
    );
  }
}
