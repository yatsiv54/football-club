import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:go_router/go_router.dart';

class TrainingCard extends StatelessWidget {
  final TrainingEntity trainingEntity;
  final int displayIndex;
  const TrainingCard({
    super.key,
    required this.trainingEntity,
    required this.displayIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('trainingdetails', extra: trainingEntity),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.grey2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: MyColors.grey3,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Image.asset('assets/images/nav/football.png'),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text('Training #$displayIndex')),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      '${formatDate(trainingEntity.date, '|')} – '
                      '${formatTime(trainingEntity.date.add(Duration(minutes: trainingEntity.durationMinutes)))}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: MyColors.grey3,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        trainingEntity.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
