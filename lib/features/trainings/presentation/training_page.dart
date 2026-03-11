import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_fab.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:fortuna/features/trainings/data/trainings_repository.dart';
import 'package:fortuna/features/trainings/presentation/widgets/training_card.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final TrainingsRepository _repo;
  @override
  void initState() {
    super.initState();
    _repo = getit<TrainingsRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(type: ButtonType.training),
      appBar: CustomAppbar(title: 'TRAINING'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: StreamBuilder<List<TrainingEntity>>(
          stream: _repo.watchTrainings(),
          builder: (context, snapshot) {
            final List<TrainingEntity> trainings =
                snapshot.data ?? const <TrainingEntity>[];
            if (trainings.isEmpty) {
              return const Center(child: Text('No trainings yet'));
            }
            return _TrainingsList(trainings: trainings);
          },
        ),
      ),
    );
  }
}

class _TrainingsList extends StatelessWidget {
  const _TrainingsList({required this.trainings});

  final List<TrainingEntity> trainings;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          TrainingCard(
            trainingEntity: trainings[index],
            displayIndex: index + 1,
          ),
      separatorBuilder: (context, _) => const SizedBox(height: 12),
      itemCount: trainings.length,
    );
  }
}
