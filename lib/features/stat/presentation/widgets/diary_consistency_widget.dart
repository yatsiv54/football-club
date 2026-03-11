import 'package:flutter/material.dart';

import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/data/diary_repository.dart';
import 'package:fortuna/core/DI/di.dart';

class DiaryConsistencyWidget extends StatefulWidget {
  const DiaryConsistencyWidget({super.key});

  @override
  State<DiaryConsistencyWidget> createState() => _DiaryConsistencyWidgetState();
}

class _DiaryConsistencyWidgetState extends State<DiaryConsistencyWidget> {
  late final DiaryRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<DiaryRepository>();
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
                'DIARY CONSISTENCY',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: StreamBuilder<List<DiaryEntity>>(
              stream: _repo.watchDiaries(),
              builder: (context, snapshot) {
                final diaries = snapshot.data ?? const <DiaryEntity>[];
                final summary = _DiarySummary.from(diaries);
                return Column(
                  spacing: 16,
                  children: [
                    _StatTile(
                      isStreak: false,
                      label: 'Entries this month',
                      value: '${summary.entriesThisMonth} ENTRIES',
                    ),
                    _StatTile(
                      isStreak: true,
                      label: 'Best streak',
                      value: '${summary.bestStreak} days in a row',
                    ),
                    _DaysRow(days: summary.lastWeek),
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

class _StatTile extends StatelessWidget {
  bool isStreak;
  final String label;
  final String value;
  _StatTile({required this.label, required this.value, required this.isStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              label, style: Theme.of(context).textTheme.bodyLarge),
            Text(overflow: TextOverflow.ellipsis,
              value,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isStreak ? Colors.white : MyColors.myYellowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DaysRow extends StatelessWidget {
  final List<_DayView> days;
  const _DaysRow({required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((d) => _DayChip(isActive: d.active))
              .toList(growable: false),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map(
                (d) => SizedBox(
                  width: 44,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    d.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final bool isActive;
  const _DayChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? MyColors.myYellowColor : MyColors.grey3,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _DiarySummary {
  final int entriesThisMonth;
  final int bestStreak;
  final List<_DayView> lastWeek;

  _DiarySummary({
    required this.entriesThisMonth,
    required this.bestStreak,
    required this.lastWeek,
  });

  factory _DiarySummary.from(List<DiaryEntity> diaries) {
    final now = DateTime.now();
    final currentMonth = diaries.where(
      (d) => d.date.year == now.year && d.date.month == now.month,
    );
    final entriesThisMonth = currentMonth.length;

    final daysSet =
        diaries
            .map((d) => DateTime(d.date.year, d.date.month, d.date.day))
            .toSet()
            .toList()
          ..sort();
    int best = 0;
    int cur = 0;
    DateTime? prev;
    for (final day in daysSet) {
      if (prev != null && day.difference(prev).inDays == 1) {
        cur += 1;
      } else {
        cur = 1;
      }
      if (cur > best) best = cur;
      prev = day;
    }

    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final List<_DayView> lastWeek = [];
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < 7; i++) {
      final target = startOfWeek.add(Duration(days: i));
      final hasEntry = daysSet.any(
        (d) =>
            d.year == target.year &&
            d.month == target.month &&
            d.day == target.day,
      );
      lastWeek.add(_DayView(label: labels[i], active: hasEntry));
    }

    return _DiarySummary(
      entriesThisMonth: entriesThisMonth,
      bestStreak: best,
      lastWeek: lastWeek,
    );
  }
}

class _DayView {
  final String label;
  final bool active;

  _DayView({required this.label, required this.active});
}
