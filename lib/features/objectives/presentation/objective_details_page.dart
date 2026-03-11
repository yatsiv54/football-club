import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';
import 'package:fortuna/features/objectives/data/objectives_repository.dart';
import 'package:fortuna/features/objectives/presentation/widgets/description_widget.dart';
import 'package:fortuna/features/objectives/presentation/widgets/objective_card.dart';
import 'package:fortuna/features/objectives/presentation/widgets/objective_info_widget.dart';
import 'package:fortuna/features/objectives/presentation/widgets/steps_view.dart';
import 'package:fortuna/features/squad/presentation/widgets/custom_detele_button.dart';
import 'package:go_router/go_router.dart';

class ObjectiveDetailsPage extends StatefulWidget {
  final ObjectiveEntity objective;
  const ObjectiveDetailsPage({super.key, required this.objective});

  @override
  State<ObjectiveDetailsPage> createState() => _ObjectiveDetailsPageState();
}

class _ObjectiveDetailsPageState extends State<ObjectiveDetailsPage> {
  late final ObjectivesRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<ObjectivesRepository>();
  }

  @override
  Widget build(BuildContext context) {
    final statusMeta = statusMetaMap[widget.objective.status]!;
    return StreamBuilder<ObjectiveEntity?>(
      stream: _repo
          .watchObjectives()
          .map(
            (list) => list.firstWhere(
              (e) => e.id == widget.objective.id,
              orElse: () => widget.objective,
            ),
          )
          .distinct(),
      initialData: widget.objective,
      builder: (context, snapshot) {
        final objective = snapshot.data ?? widget.objective;
        return Scaffold(
          appBar: CustomAppbar(
            title: 'OBJECTIVE DETAILS',
            action: objective.status != ObjectiveStatus.archived
                ? EditButton(
                    onTap: () => context.pushNamed(
                      'objectives/addobjective',
                      extra: objective,
                    ),
                  )
                : null,
            leading: const LayoutBackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            objective.title.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 10),
                          ObjectiveStatusBadge(
                            text: statusMeta.label,
                            color: statusMeta.color,
                          ),
                          SizedBox(height: 24),
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
                                  text: categoryText(widget.objective.category),
                                  title: 'Category',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: MyColors.grey3,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(12),
                              child: ProgressRow(
                                objective: objective,
                                color: MyColors.grey4,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ObjectiveDescriptionWidget(),
                          SizedBox(height: 20),
                          StepsView(
                            objective: objective,
                            onStatusChanged: _saveObjective,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  minimum: EdgeInsets.only(top: 12),
                  top: false,
                  child: Column(
                    children: [
                      if (objective.status != ObjectiveStatus.archived) ...[
                        _ActionButton(
                          objective: objective,
                          onSave: _saveObjective,
                          onCloseDetails: () {
                            if (mounted) Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomDeleteButton(
                          toDelete: objective,
                          onTap: () async => _deleteObjective(objective.id),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveObjective(ObjectiveEntity updated) async {
    await _repo.updateObjective(
      id: updated.id,
      title: updated.title,
      status: updated.status,
      category: updated.category,
      description: updated.description,
      deadline: updated.deadline,
      goalType: updated.goalType,
      steps: updated.steps,
    );
  }

  Future<void> _deleteObjective(int id) async {
    await _repo.deleteObjective(id);
    if (!mounted) return;
    context.pop();
  }
}

class _ActionButton extends StatelessWidget {
  final ObjectiveEntity objective;
  final ValueChanged<ObjectiveEntity> onSave;
  final VoidCallback onCloseDetails;

  const _ActionButton({
    required this.objective,
    required this.onSave,
    required this.onCloseDetails,
  });

  @override
  Widget build(BuildContext context) {
    final allDone = _allDone(objective);
    final label = allDone ? 'Mark as Archived' : 'Mark as Completed';

    return GestureDetector(
      onTap: () {
        if (allDone) {
          onSave(
            ObjectiveEntity(
              id: objective.id,
              title: objective.title,
              status: ObjectiveStatus.archived,
              category: objective.category,
              description: objective.description,
              deadline: objective.deadline,
              goalType: objective.goalType,
              steps: objective.steps,
            ),
          );
          onCloseDetails();
        } else {
          final updatedSteps = Map<String, bool>.from(objective.steps);
          updatedSteps.updateAll((key, value) => true);
          onSave(
            ObjectiveEntity(
              id: objective.id,
              title: objective.title,
              status: ObjectiveStatus.completed,
              category: objective.category,
              description: objective.description,
              deadline: objective.deadline,
              goalType: objective.goalType,
              steps: updatedSteps,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: allDone ? Colors.transparent : MyColors.myYellowColor,
          border: allDone
              ? BoxBorder.all(color: MyColors.myYellowColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            overflow: TextOverflow.ellipsis,
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: allDone ? MyColors.myYellowColor : Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  bool _allDone(ObjectiveEntity objective) {
    if (objective.goalType == GoalType.simple) {
      return objective.status == ObjectiveStatus.completed ||
          objective.status == ObjectiveStatus.archived;
    }
    if (objective.steps.isEmpty) return false;
    return objective.steps.values.every((done) => done == true);
  }
}
