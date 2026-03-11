import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class TimeChip extends StatelessWidget {
  final String location;
  final bool expanded;
  final double height;

  const TimeChip({
    super.key,
    required this.location,
    this.expanded = false,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final double? width = expanded ? null : 175;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: MyColors.grey3,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Image.asset('assets/images/home/calendar.png'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                location,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
