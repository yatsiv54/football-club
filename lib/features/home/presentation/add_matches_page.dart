import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/home/widgets/custom_clock_picker.dart';
import 'package:fortuna/features/home/widgets/custom_date_picker.dart';
import 'package:fortuna/features/home/widgets/custom_score_box.dart';
import 'package:fortuna/features/home/widgets/custom_status_switcher.dart'
    as status_ui;
import 'package:fortuna/features/home/widgets/custom_text_field.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/matches/data/match_entity.dart' as data;
import 'package:fortuna/features/matches/data/repositories/matches_repository.dart';
import 'package:go_router/go_router.dart';

class AddMatchesPage extends StatefulWidget {
  const AddMatchesPage({super.key, this.initialMatch});

  final data.MatchEntity? initialMatch;

  @override
  State<AddMatchesPage> createState() => _AddMatchesPageState();
}

class _AddMatchesPageState extends State<AddMatchesPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController dateController;
  late final TextEditingController hoursController;
  late final TextEditingController minutesController;
  late final TextEditingController locationController;
  late final TextEditingController notesController;
  status_ui.MatchStatus? _status;
  String _homeScore = '';
  String _awayScore = '';
  String? _initialHomeScore;
  String? _initialAwayScore;

  status_ui.MatchStatus? get status => _status;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dateController = TextEditingController();
    hoursController = TextEditingController();
    minutesController = TextEditingController();
    locationController = TextEditingController();
    notesController = TextEditingController();
    _prefillIfEditing();
    _addListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.initialMatch != null
        ? 'EDIT MATCH'
        : 'ADD MATCH';

    return Scaffold(
      appBar: CustomAppbar(title: title, leading: const LayoutBackButton()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(overflow: TextOverflow.ellipsis,
                        'Opponent',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        validator: ValidatorType.name,
                        hint: 'Enter opponent name',
                        controller: nameController,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      const SizedBox(height: 20),
                      Text(overflow: TextOverflow.ellipsis,
                        'Date & Time',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                              controller: dateController,
                              validatorType: ValidatorType.date,
                              firstDate: DateTime(1900),
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustomClockPicker(
                            hoursController: hoursController,
                            minutesController: minutesController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(overflow: TextOverflow.ellipsis,
                        'Location',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: locationController,
                        validator: ValidatorType.location,
                        hint: 'Enter stadium or field',
                        onChanged: (_) => _updateCanSave(),
                      ),
                      const SizedBox(height: 20),
                      Text(overflow: TextOverflow.ellipsis,
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      status_ui.StatusSwitcher(
                        status: _status,
                        onChanged: (value) => setState(() {
                          _status = value;
                          _normalizeDateForStatus();
                          _updateCanSave();
                        }),
                      ),
                      const SizedBox(height: 20),
                      if (_status == status_ui.MatchStatus.finished) ...[
                        Text(overflow: TextOverflow.ellipsis,
                          'Score',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        _ScoreInputs(
                          initialHome: _initialHomeScore,
                          initialAway: _initialAwayScore,
                          onChanged: (home, away) {
                            _homeScore = home;
                            _awayScore = away;
                            _updateCanSave();
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(overflow: TextOverflow.ellipsis,
                        'Notes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        keyboardType: TextInputType.multiline,
                        hint: 'Enter note',
                        height: 160,
                        controller: notesController,
                        validator: ValidatorType.notes,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              minimum: EdgeInsets.only(top: 15),
              top: false,
              child: CustomSaveButton(onPressed: _onSave, enabled: _canSave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (_status == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select match status')));
      return;
    }

    final DateTime? dateTime = _parseDateTime();
    if (dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid date and time')),
      );
      return;
    }

    final data.MatchStatus statusToSave =
        _status == status_ui.MatchStatus.finished
        ? data.MatchStatus.finished
        : data.MatchStatus.upcoming;

    final String scoreToSave = statusToSave == data.MatchStatus.finished
        ? '${_homeScore.trim()}:${_awayScore.trim()}'
        : '';

    if (widget.initialMatch != null) {
      await getit<MatchesRepository>().updateMatch(
        id: widget.initialMatch!.id,
        opponent: nameController.text.trim(),
        place: locationController.text.trim(),
        dateTime: dateTime,
        status: statusToSave,
        score: scoreToSave.trim(),
        notes: notesController.text.trim(),
      );
    } else {
      await getit<MatchesRepository>().addMatch(
        opponent: nameController.text.trim(),
        place: locationController.text.trim(),
        dateTime: dateTime,
        status: statusToSave,
        score: scoreToSave.trim(),
        notes: notesController.text.trim(),
      );
    }

    if (!mounted) return;
    context.pop();
  }

  DateTime? _parseDateTime() {
    final dateParts = dateController.text.split(RegExp(r'[./]'));
    if (dateParts.length != 3) return null;

    final int? day = int.tryParse(dateParts[0]);
    final int? month = int.tryParse(dateParts[1]);
    final int? year = int.tryParse(dateParts[2]);
    final int? hours = int.tryParse(hoursController.text);
    final int? minutes = int.tryParse(minutesController.text);

    if (day == null || month == null || year == null) return null;
    if (hours == null || minutes == null) return null;

    return DateTime(year, month, day, hours, minutes);
  }

  void _prefillIfEditing() {
    final initial = widget.initialMatch;
    if (initial == null) return;

    nameController.text = initial.opponent;
    dateController.text = _formatDate(initial.dateTime);
    hoursController.text = initial.dateTime.hour.toString().padLeft(2, '0');
    minutesController.text = initial.dateTime.minute.toString().padLeft(2, '0');
    locationController.text = initial.location;
    notesController.text = initial.notes;
    _status = initial.status == data.MatchStatus.finished
        ? status_ui.MatchStatus.finished
        : status_ui.MatchStatus.upcoming;

    if (initial.score.isNotEmpty) {
      final parts = initial.score.split(RegExp('[-:]'));
      if (parts.length == 2) {
        _homeScore = parts[0];
        _awayScore = parts[1];
        _initialHomeScore = _homeScore;
        _initialAwayScore = _awayScore;
      }
    }
    _syncStatusWithDate();
    _updateCanSave();
  }

  void _addListeners() {
    nameController.addListener(_updateCanSave);
    dateController.addListener(_updateCanSave);
    hoursController.addListener(_updateCanSave);
    minutesController.addListener(_updateCanSave);
    locationController.addListener(_updateCanSave);
  }

  void _updateCanSave() {
    _syncStatusWithDate();
    final bool hasStatus = _status != null;
    final bool hasOpponent = nameController.text.trim().isNotEmpty;
    final bool hasLocation = locationController.text.trim().isNotEmpty;
    final bool dateOk = _parseDateTime() != null;

    bool scoresOk = true;
    if (_status == status_ui.MatchStatus.finished) {
      scoresOk = _homeScore.isNotEmpty && _awayScore.isNotEmpty;
    }

    final bool canSave =
        hasStatus && hasOpponent && hasLocation && dateOk && scoresOk;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }

  void _normalizeDateForStatus() {
    final dt = _parseDateTime();
    if (dt == null || _status == null) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(dt.year, dt.month, dt.day);
    if (_status == status_ui.MatchStatus.upcoming &&
        selectedDate.isBefore(today)) {
      final tomorrow = today.add(const Duration(days: 1));
      dateController.text = _formatDate(tomorrow);
    } else if (_status == status_ui.MatchStatus.finished &&
        selectedDate.isAfter(today)) {
      final yesterday = today.subtract(const Duration(days: 1));
      dateController.text = _formatDate(yesterday);
    }
  }

  void _syncStatusWithDate() {
    final dt = _parseDateTime();
    if (dt == null) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(dt.year, dt.month, dt.day);

    if (selectedDate.isBefore(today) &&
        _status != status_ui.MatchStatus.finished) {
      setState(() {
        _status = status_ui.MatchStatus.finished;
      });
    } else if (selectedDate.isAfter(today) &&
        _status != status_ui.MatchStatus.upcoming) {
      setState(() {
        _status = status_ui.MatchStatus.upcoming;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _ScoreInputs extends StatefulWidget {
  const _ScoreInputs({
    required this.onChanged,
    this.initialHome,
    this.initialAway,
  });

  final void Function(String home, String away) onChanged;
  final String? initialHome;
  final String? initialAway;

  @override
  State<_ScoreInputs> createState() => _ScoreInputsState();
}

class _ScoreInputsState extends State<_ScoreInputs> {
  late final TextEditingController _homeController;
  late final TextEditingController _awayController;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController();
    _awayController = TextEditingController();
    if (widget.initialHome != null) {
      _homeController.text = widget.initialHome!;
    }
    if (widget.initialAway != null) {
      _awayController.text = widget.initialAway!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_homeController.text, _awayController.text);
    });
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScoreBox(
          controller: _homeController,
          onChanged: (val) => widget.onChanged(val, _awayController.text),
        ),
        const SizedBox(width: 6),
        Text('–', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 6),
        ScoreBox(
          controller: _awayController,
          onChanged: (val) => widget.onChanged(_homeController.text, val),
        ),
      ],
    );
  }
}
