import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';
import 'package:fortuna/features/objectives/presentation/widgets/objective_info_widget.dart';

class ObjectiveCard extends StatelessWidget {
  final ObjectiveEntity objective;
  const ObjectiveCard({super.key, required this.objective});

  @override
  Widget build(BuildContext context) {
    final statusMeta = statusMetaMap[objective.status]!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: MyColors.grey3,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    objective.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ObjectiveStatusBadge(
                  text: statusMeta.label,
                  color: statusMeta.color,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(12, 6, 12, 12),
            child: Column(
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ObjectiveInfoWidget(
                        text: formatBirthdayDate2(
                          objective.deadline ?? DateTime.now(),
                        ),
                        title: 'Deadline',
                      ),
                    ),
                    Expanded(
                      child: ObjectiveInfoWidget(
                        text: categoryText(objective.category),
                        title: 'Category',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (objective.goalType != GoalType.simple)
                  ProgressRow(objective: objective, color: MyColors.grey3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ObjectiveStatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  const ObjectiveStatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        overflow: TextOverflow.ellipsis,
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
    );
  }
}

class StatusMeta {
  final String label;
  final Color color;

  const StatusMeta({required this.label, required this.color});
}

final statusMetaMap = {
  ObjectiveStatus.active: StatusMeta(
    label: 'In Progress',
    color: MyColors.myYellowColor,
  ),
  ObjectiveStatus.completed: StatusMeta(
    label: 'Completed',
    color: Color.fromRGBO(69, 202, 18, 1),
  ),
  ObjectiveStatus.archived: StatusMeta(
    label: 'Archived',
    color: Color.fromRGBO(0, 178, 255, 1),
  ),
};

class ProgressRow extends StatelessWidget {
  final ObjectiveEntity objective;
  final Color color;
  const ProgressRow({super.key, required this.objective, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = _progressValue(objective);
    final percentText = '${(progress * 100).round()}%';
    return Row(
      children: [
        Text('Progress', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: MyColors.myYellowColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          overflow: TextOverflow.ellipsis,
          percentText,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  double _progressValue(ObjectiveEntity objective) {
    if (objective.steps.isEmpty) {
      return objective.status == ObjectiveStatus.completed ? 1.0 : 0.0;
    }
    final total = objective.steps.length;
    final completed = objective.steps.values
        .where((isDone) => isDone == true)
        .length;
    return total == 0 ? 0.0 : completed / total;
  }
}
