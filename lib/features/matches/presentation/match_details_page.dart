import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/layout/widgets/edit_button.dart';
import 'package:fortuna/features/matches/data/match_entity.dart';
import 'package:fortuna/features/matches/data/repositories/matches_repository.dart';
import 'package:fortuna/features/matches/presentation/widgets/details_info_chip.dart';
import 'package:fortuna/features/matches/presentation/widgets/notes_widget.dart';
import 'package:fortuna/features/matches/presentation/widgets/score_widget.dart';
import 'package:fortuna/features/matches/presentation/widgets/status_chip.dart';
import 'package:fortuna/features/squad/presentation/widgets/custom_detele_button.dart';
import 'package:go_router/go_router.dart';

class MatchDetailsPage extends StatefulWidget {
  final MatchEntity match;
  const MatchDetailsPage({super.key, required this.match});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  late final MatchesRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = getit<MatchesRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MatchEntity?>(
      stream: _repository.watchMatch(widget.match.id),
      initialData: widget.match,
      builder: (context, snapshot) {
        final match = snapshot.data ?? widget.match;
        return Scaffold(
          floatingActionButton: CustomDeleteButton(
            onTap: () async => _deleteMatch(match.id),
            toDelete: match,
          ),
          appBar: CustomAppbar(
            title: 'MATCH DETAILS',
            leading: const LayoutBackButton(),
            action: EditButton(
              onTap: () {
                context.pushNamed('addmatch', extra: match);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Opponent',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      match.opponent.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    StatusChip(status: match.status),
                    const SizedBox(height: 24),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: DetailsInfoChip(
                            title: formatDate(match.dateTime, '—'),
                            iconPath: 'assets/images/home/calendar.png',
                            height: 80,
                          ),
                        ),
                        Expanded(
                          child: DetailsInfoChip(
                            title: match.location,
                            iconPath: 'assets/images/home/location.png',
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    match.status == MatchStatus.finished
                        ? ScoreWidget(score: match.score)
                        : SizedBox.shrink(),
                    const SizedBox(height: 20),
                    NotesWidget(notes: match.notes),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteMatch(int id) async {
    await _repository.deleteMatch(id);
    if (!mounted) return;
    context.pop();
  }
}
