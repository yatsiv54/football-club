import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/matches/presentation/widgets/notes_widget.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';
import 'package:fortuna/features/squad/data/players_repository.dart';
import 'package:fortuna/features/squad/presentation/widgets/contact_info_widget.dart';
import 'package:fortuna/features/squad/presentation/widgets/player_card.dart';
import 'package:fortuna/features/squad/presentation/widgets/custom_detele_button.dart';
import 'package:fortuna/features/squad/presentation/widgets/player_info_chip.dart';
import 'package:go_router/go_router.dart';

class PlayerDetailPage extends StatefulWidget {
  final PlayerEntity player;
  const PlayerDetailPage({super.key, required this.player});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  late final PlayersRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = getit<PlayersRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerEntity?>(
      stream: _repository.watchPlayer(widget.player.id),
      initialData: widget.player,
      builder: (context, snapshot) {
        final player = snapshot.data ?? widget.player;
        return Scaffold(
          floatingActionButton: CustomDeleteButton(
            onTap: () async => _deletePlayer(player.id),
            toDelete: player,
          ),
          appBar: CustomAppbar(
            title: 'PLAYER DETAILS',
            leading: const LayoutBackButton(),
            action: EditButton(
              onTap: () {
                context.pushNamed('addplayer', extra: player);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(overflow: TextOverflow.ellipsis,
                        player.name.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: PositionChip(position: player.position)),
                    SizedBox(height: 24),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: PlayerInfoChip(
                            title: 'Jersey Number',
                            body: player.jerseyNumber != null
                                ? '#${player.jerseyNumber}'
                                : '-',
                          ),
                        ),
                        Expanded(
                          child: PlayerInfoChip(
                            title: 'Date of Birth',
                            body: formatBirthdayDate(player.dob),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ContactInfoWidget(
                      phoneNumber: player.phoneNumber,
                      email: player.email,
                    ),
                    SizedBox(height: 20),
                    NotesWidget(notes: player.note),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePlayer(int id) async {
    await _repository.deletePlayer(id);
    if (!mounted) return;
    context.pop();
  }
}
