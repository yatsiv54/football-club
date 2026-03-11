import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_fab.dart';
import 'package:fortuna/features/diary/presentation/widgets/diary_card.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/data/diary_repository.dart';
import 'package:go_router/go_router.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final DiaryRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<DiaryRepository>();
    _repo.debugPrintDiaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(type: ButtonType.diary),
      appBar: CustomAppbar(title: 'DIARY'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: StreamBuilder<List<DiaryEntity>>(
          stream: _repo.watchDiaries(),
          builder: (context, snapshot) {
            final diaries = snapshot.data ?? const <DiaryEntity>[];
            if (diaries.isEmpty) {
              return const Center(child: Text('No diary entries yet'));
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final diary = diaries[index];
                return GestureDetector(
                  onTap: () => context.pushNamed('diarydetails', extra: diary),
                  child: DiaryCard(diary: diary),
                );
              },
              separatorBuilder: (context, _) => const SizedBox(height: 20),
              itemCount: diaries.length,
            );
          },
        ),
      ),
    );
  }
}
