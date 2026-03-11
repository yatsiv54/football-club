import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:fortuna/features/trainings/data/trainings_repository.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({super.key});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  late final TrainingsRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<TrainingsRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.grey3,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Text(
                'TRAINING ACTIVITY',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: StreamBuilder<List<TrainingEntity>>(
              stream: _repo.watchTrainings(),
              builder: (context, snapshot) {
                final trainings = snapshot.data ?? const <TrainingEntity>[];
                final stats = _WeeklyStats.from(trainings);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActivityColumns(weekCounts: stats.weekCounts),
                    const SizedBox(height: 16),
                    _AvgTile(avgPerWeek: stats.avgPerWeekText),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityColumns extends StatelessWidget {
  final List<int> weekCounts;
  const _ActivityColumns({required this.weekCounts});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        4,
        (index) =>
            _ChipsColumn(label: 'Week ${index + 1}', count: weekCounts[index]),
      ),
    );
  }
}

class _ChipsColumn extends StatelessWidget {
  final String label;
  final int count;
  const _ChipsColumn({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final chips = List.generate(count.clamp(0, 7), (_) => const _WeekChip());
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 4,
      children: [
        ...chips,
        const SizedBox(height: 2),
        Text(
          overflow: TextOverflow.ellipsis,
          label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _WeekChip extends StatelessWidget {
  const _WeekChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: MyColors.myYellowColor,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _AvgTile extends StatelessWidget {
  final String avgPerWeek;
  const _AvgTile({required this.avgPerWeek});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              overflow: TextOverflow.ellipsis,
              'Average per week',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              '$avgPerWeek / WEEK',
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: MyColors.myYellowColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyStats {
  final List<int> weekCounts;
  final String avgPerWeekText;

  _WeeklyStats({required this.weekCounts, required this.avgPerWeekText});

  factory _WeeklyStats.from(List<TrainingEntity> trainings) {
    final now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

    final counts = List<int>.filled(4, 0);
    for (final t in trainings) {
      if (t.date.year != currentYear || t.date.month != currentMonth) {
        continue;
      }

      final int dayOfMonth = t.date.day;
      int idx = (dayOfMonth - 1) ~/ 7;
      if (idx > 3) idx = 3;
      counts[idx] += 1;
    }

    final total = counts.reduce((a, b) => a + b);
    final avg = total / 4;
    final avgText = avg % 1 == 0
        ? avg.toInt().toString()
        : avg.toStringAsFixed(1);

    return _WeeklyStats(weekCounts: counts, avgPerWeekText: avgText);
  }
}
