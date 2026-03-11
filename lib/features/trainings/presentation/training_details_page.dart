import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/squad/presentation/widgets/custom_detele_button.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:fortuna/features/trainings/data/trainings_repository.dart';
import 'package:fortuna/features/matches/presentation/widgets/notes_widget.dart';
import 'package:fortuna/features/trainings/presentation/widgets/focus_widget.dart';
import 'package:fortuna/features/trainings/presentation/widgets/training_info_widget.dart';
import 'package:go_router/go_router.dart';

class TrainingDetailsPage extends StatefulWidget {
  final TrainingEntity training;
  const TrainingDetailsPage({super.key, required this.training});

  @override
  State<TrainingDetailsPage> createState() => _TrainingDetailsPageState();
}

class _TrainingDetailsPageState extends State<TrainingDetailsPage> {
  late final TrainingsRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = getit<TrainingsRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrainingEntity>>(
      stream: _repository.watchTrainings(),
      builder: (context, snapshot) {
        final trainings = snapshot.data ?? const <TrainingEntity>[];
        final trainingIndex =
            trainings.indexWhere((t) => t.id == widget.training.id);
        final training = trainingIndex != -1
            ? trainings[trainingIndex]
            : widget.training;
        final displayIndex =
            trainingIndex != -1 ? trainingIndex + 1 : widget.training.id;
        return Scaffold(
          floatingActionButton: CustomDeleteButton(
            onTap: () async => _deleteTraining(training.id),
            toDelete: training,
          ),
          appBar: CustomAppbar(
            title: 'TRAINING #$displayIndex',
            leading: const LayoutBackButton(),
            action: EditButton(
              onTap: () {
                context.pushNamed('addtraining', extra: training);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FocusWidget(title: training.title),
                    SizedBox(height: 12),
                    Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: TrainingInfoWidget(
                            icon: 'assets/images/training/calendar.png',
                            title:
                                '${formatDateForTraining(training.date, '|')} – '
                                '${formatTime(training.date.add(Duration(minutes: training.durationMinutes)))}',
                          ),
                        ),
                        Expanded(
                          child: TrainingInfoWidget(
                            icon: 'assets/images/training/stopwatch.png',
                            title: '${training.durationMinutes}\n minutes',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    NotesWidget(notes: training.notes),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteTraining(int id) async {
    await _repository.deleteTraining(id);
    if (!mounted) return;
    context.pop();
  }
}
