import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

enum MatchStatus { upcoming, finished }

class StatusSwitcher extends StatelessWidget {
  const StatusSwitcher({
    super.key,
    required this.status,
    required this.onChanged,
  });

  final MatchStatus? status;
  final ValueChanged<MatchStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = status == MatchStatus.upcoming;
    final bool isFinished = status == MatchStatus.finished;

    return Row(
      children: [
        Expanded(
          child: _StatusTile(
            label: 'Upcoming',
            color: MyColors.myYellowColor,
            selected: isUpcoming,
            onTap: () => onChanged(MatchStatus.upcoming),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusTile(
            label: 'Finished',
            color: Colors.green,
            selected: isFinished,
            onTap: () => onChanged(MatchStatus.finished),
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ) ??
        TextStyle(color: color, fontWeight: FontWeight.w700);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: MyColors.grey2,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: MyColors.myYellowColor, width: 1)
              : Border.all(color: Colors.transparent, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(label, style: textStyle),
      ),
    );
  }
}
