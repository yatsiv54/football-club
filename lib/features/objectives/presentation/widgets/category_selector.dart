import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';

class CategorySelector extends StatelessWidget {
  final ObjectiveCategory? selected;
  final ValueChanged<ObjectiveCategory> onChanged;
  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ObjectiveCategory.values;
    final labels = {
      ObjectiveCategory.fitness: 'Fitness',
      ObjectiveCategory.training: 'Training',
      ObjectiveCategory.performance: 'Performance',
      ObjectiveCategory.recovery: 'Recovery',
      ObjectiveCategory.mindset: 'Mindset',
      ObjectiveCategory.teamwork: 'Teamwork',
      ObjectiveCategory.seasonGoal: 'Season Goal',
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories
          .map(
            (c) => _ChipButton(
              text: labels[c]!,
              selected: selected == c,
              onTap: () => onChanged(c),
            ),
          )
          .toList(),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ChipButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: BoxBorder.all(
            width: 1,
            color: selected ? MyColors.myYellowColor : Colors.transparent,
          ),
          color: MyColors.grey3,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
