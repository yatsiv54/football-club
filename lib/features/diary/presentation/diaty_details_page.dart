import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/data/diary_repository.dart';
import 'package:fortuna/features/diary/presentation/widgets/diary_info_widget.dart';
import 'package:fortuna/features/diary/presentation/widgets/mood_selector.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/matches/presentation/widgets/notes_widget.dart';
import 'package:fortuna/features/squad/presentation/widgets/custom_detele_button.dart';
import 'package:fortuna/features/trainings/presentation/widgets/training_info_widget.dart';
import 'package:go_router/go_router.dart';

class DiaryDetailsPage extends StatefulWidget {
  final DiaryEntity diary;
  const DiaryDetailsPage({super.key, required this.diary});

  @override
  State<DiaryDetailsPage> createState() => _DiaryDetailsPageState();
}

class _DiaryDetailsPageState extends State<DiaryDetailsPage> {
  late final DiaryRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = getit<DiaryRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DiaryEntity?>(
      stream: _repository.watchDiary(widget.diary.id),
      initialData: widget.diary,
      builder: (context, snapshot) {
        final diary = snapshot.data ?? widget.diary;
        return Scaffold(
          floatingActionButton: CustomDeleteButton(
            onTap: () async => _deleteDiary(diary.id),
            toDelete: diary,
          ),
          appBar: CustomAppbar(
            title: 'DIARY ENTRY',
            leading: const LayoutBackButton(),
            action: EditButton(
              onTap: () {
                context.pushNamed('adddiary', extra: diary);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      diary.title.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: DiaryInfoWidget(
                            icon: 'assets/images/training/calendar.png',
                            title: Text(formatDateDiary(diary.date)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: DiaryInfoWidget(
                            icon: moodMap[moodFromInt(diary.mood)]!.icon,
                            title: Text(overflow: TextOverflow.ellipsis,
                              moodMap[moodFromInt(diary.mood)]!.title,
                              style: TextStyle(
                                color: moodMap[moodFromInt(diary.mood)]!.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    NotesWidget(notes: diary.notes),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteDiary(int id) async {
    await _repository.deleteDiary(id);
    if (!mounted) return;
    context.pop();
  }
}
