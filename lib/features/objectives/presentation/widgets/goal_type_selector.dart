import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';

class GoalTypeSelector extends StatelessWidget {
  final GoalType selected;
  final ValueChanged<GoalType> onChanged;
  const GoalTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Chip(
            text: 'Simple',
            selected: selected == GoalType.simple,
            onTap: () => onChanged(GoalType.simple),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Chip(
            text: 'Step-Based',
            selected: selected == GoalType.stepBased,
            onTap: () => onChanged(GoalType.stepBased),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: BoxBorder.all(
            color: selected ? MyColors.myYellowColor : Colors.transparent,
          ),
          color: MyColors.grey3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(overflow: TextOverflow.ellipsis,
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
