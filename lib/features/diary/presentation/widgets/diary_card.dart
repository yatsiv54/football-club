import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/presentation/widgets/mood_selector.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntity diary;
  const DiaryCard({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: diary.notes.isEmpty ? 105 : 140,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.grey3,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24,
                    child: Image.asset('assets/images/nav/diary.png'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      diary.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    child: Image.asset(moodMap[moodFromInt(diary.mood)]!.icon),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    moodMap[moodFromInt(diary.mood)]!.title,
                    style: TextStyle(
                      color: moodMap[moodFromInt(diary.mood)]!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  formatDateDiary(diary.date),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white60),
                ),
                if (diary.notes.isNotEmpty) SizedBox(height: 8),
                if (diary.notes.isNotEmpty)
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    diary.notes,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
