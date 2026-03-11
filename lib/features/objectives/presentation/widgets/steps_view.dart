import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';

class StepsView extends StatelessWidget {
  final ObjectiveEntity objective;
  final ValueChanged<ObjectiveEntity> onStatusChanged;

  const StepsView({
    super.key,
    required this.objective,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (objective.goalType != GoalType.stepBased || objective.steps.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = objective.steps.entries.toList();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Steps', style: Theme.of(context).textTheme.bodyMedium),
          ...List.generate(entries.length, (index) {
            final entry = entries[index];
            final title = entry.key;
            final done = entry.value;
            return _StepItem(
              status: objective.status,
              index: index + 1,
              title: title,
              done: done,
              onToggle: () {
                final updatedSteps = Map<String, bool>.from(objective.steps);
                updatedSteps[title] = !done;
                final updated = ObjectiveEntity(
                  id: objective.id,
                  title: objective.title,
                  status: updatedSteps.values.every((e) => e)
                      ? ObjectiveStatus.completed
                      : objective.status,
                  category: objective.category,
                  description: objective.description,
                  deadline: objective.deadline,
                  goalType: objective.goalType,
                  steps: updatedSteps,
                );
                onStatusChanged(updated);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final ObjectiveStatus status;
  final int index;
  final String title;
  final bool done;
  final VoidCallback onToggle;

  const _StepItem({
    required this.index,
    required this.title,
    required this.done,
    required this.onToggle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: MyColors.grey3,
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(color: MyColors.grey4),
      ),
      child: Row(
        children: [
          _CheckCircle(done: done, onTap: onToggle, status: status),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  final ObjectiveStatus status;
  final bool done;
  final VoidCallback onTap;
  const _CheckCircle({
    required this.done,
    required this.onTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status != ObjectiveStatus.archived ? onTap : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: done ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: done
            ? const Icon(Icons.check, size: 15, color: Colors.black)
            : null,
      ),
    );
  }
}
