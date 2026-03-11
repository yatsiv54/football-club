import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_fab.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';
import 'package:fortuna/features/squad/data/players_repository.dart';
import 'package:fortuna/features/squad/presentation/widgets/player_card.dart';
import 'package:go_router/go_router.dart';

class SquadPage extends StatefulWidget {
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  late final PlayersRepository _repo;
  @override
  void initState() {
    super.initState();
    _repo = getit<PlayersRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(type: ButtonType.squad),
      appBar: CustomAppbar(title: 'SQUAD'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: StreamBuilder<List<PlayerEntity>>(
          stream: _repo.watchPlayers(),
          builder: (context, snapshot) {
            final players = snapshot.data ?? const <PlayerEntity>[];
            if (players.isEmpty) { 
              return const Center(child: Text('No players yet'));
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final player = players[index];
                return GestureDetector(
                  onTap: () =>
                      context.pushNamed('playerdetails', extra: player),
                  child: PlayerCard(player: player),
                );
              },
              separatorBuilder: (context, _) =>
                  const SizedBox(height: 12),
              itemCount: players.length,
            );
          },
        ),
      ),
    );
  }
}


