import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_fab.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';
import 'package:fortuna/features/objectives/data/objectives_repository.dart';
import 'package:fortuna/features/objectives/presentation/widgets/objective_card.dart';
import 'package:go_router/go_router.dart';
import 'package:fortuna/core/theme/colors.dart';

class ObjectivesPage extends StatefulWidget {
  const ObjectivesPage({super.key});

  @override
  State<ObjectivesPage> createState() => _ObjectivesPageState();
}

class _ObjectivesPageState extends State<ObjectivesPage> {
  late final ObjectivesRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = getit<ObjectivesRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(type: ButtonType.objectives),
      appBar: CustomAppbar(
        title: 'SEASON OBJECTIVES',
        leading: LayoutBackButton(),
      ),
      body: StreamBuilder<List<ObjectiveEntity>>(
        stream: _repo.watchObjectives(),
        builder: (context, snapshot) {
          final objectives = snapshot.data ?? const <ObjectiveEntity>[];
          return ObjectivesTabs(objectives: objectives);
        },
      ),
    );
  }
}

class ObjectivesTabs extends StatelessWidget {
  final List<ObjectiveEntity> objectives;
  const ObjectivesTabs({super.key, required this.objectives});

  @override
  Widget build(BuildContext context) {
    final active = objectives
        .where((o) => o.status == ObjectiveStatus.active)
        .toList();
    final completed = objectives
        .where((o) => o.status == ObjectiveStatus.completed)
        .toList();
    final archived = objectives
        .where((o) => o.status == ObjectiveStatus.archived)
        .toList();

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: MyColors.myBackgroundColor),
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: MyColors.myYellowColor,
              dividerColor: MyColors.grey2,

              indicatorWeight: 2,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
              labelColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Archived'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TabBarView(
              children: [
                _ObjectiveList(
                  objectives: objectives,
                  emptyLabel: 'No objectives yet',
                ),
                _ObjectiveList(
                  objectives: active,
                  emptyLabel: 'No active objectives',
                ),
                _ObjectiveList(
                  objectives: completed,
                  emptyLabel: 'No completed objectives',
                ),
                _ObjectiveList(
                  objectives: archived,
                  emptyLabel: 'No archived objectives',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjectiveList extends StatelessWidget {
  final List<ObjectiveEntity> objectives;
  final String emptyLabel;
  const _ObjectiveList({required this.objectives, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (objectives.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        final objective = objectives[index];
        return GestureDetector(
          onTap: () =>
              context.pushNamed('objectives/details', extra: objective),
          child: ObjectiveCard(objective: objective),
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 12),
      itemCount: objectives.length,
    );
  }
}
