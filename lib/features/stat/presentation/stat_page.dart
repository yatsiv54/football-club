import 'package:flutter/material.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/stat/presentation/widgets/activity_widget.dart';
import 'package:fortuna/features/stat/presentation/widgets/diary_consistency_widget.dart';
import 'package:fortuna/features/stat/presentation/widgets/open_objectives_button.dart';
import 'package:fortuna/features/stat/presentation/widgets/total_widget.dart';
import 'package:go_router/go_router.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'FORTUNA PROGRESS',
        leading: LayoutBackButton(),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              TotalWidget(),
              ActivityWidget(),
              DiaryConsistencyWidget(),
              OpenObjectivesButton(
                onPressed: () => context.pushNamed('objectives'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
