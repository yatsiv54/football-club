import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/home/widgets/custom_clock_picker.dart';
import 'package:fortuna/features/home/widgets/custom_date_picker.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/trainings/data/training_entity.dart';
import 'package:fortuna/features/trainings/data/trainings_repository.dart';
import 'package:go_router/go_router.dart';

class AddTrainingPage extends StatefulWidget {
  const AddTrainingPage({super.key, this.initialTraining});

  final TrainingEntity? initialTraining;

  @override
  State<AddTrainingPage> createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController dateController;
  late final TextEditingController hoursController;
  late final TextEditingController minutesController;
  late final TextEditingController durationController;
  late final TextEditingController notesController;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dateController = TextEditingController();
    hoursController = TextEditingController();
    minutesController = TextEditingController();
    durationController = TextEditingController();
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
    durationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.initialTraining != null
        ? 'EDIT TRAINING'
        : 'ADD TRAINING';
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
                      Text(
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
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomClockPicker(
                            hoursController: hoursController,
                            minutesController: minutesController,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Focus',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: 'Training focus',
                        controller: nameController,
                        validator: ValidatorType.name,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        hint: 'e.g. 90 minutes',
                        keyboardType: const TextInputType.numberWithOptions(),
                        controller: durationController,
                        validator: ValidatorType.location,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
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

    final DateTime? dateTime = _parseDateTime();
    if (dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid date and time')),
      );
      return;
    }

    final int? duration = int.tryParse(durationController.text.trim());
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter duration in minutes')),
      );
      return;
    }

    final repo = getit<TrainingsRepository>();

    if (widget.initialTraining != null) {
      await repo.updateTraining(
        id: widget.initialTraining!.id,
        title: nameController.text.trim(),
        notes: notesController.text.trim(),
        date: dateTime,
        durationMinutes: duration,
      );
    } else {
      await repo.addTraining(
        title: nameController.text.trim(),
        notes: notesController.text.trim(),
        date: dateTime,
        durationMinutes: duration,
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
    final initial = widget.initialTraining;
    if (initial == null) return;

    nameController.text = initial.title;
    dateController.text =
        '${initial.date.day.toString().padLeft(2, '0')}/${initial.date.month.toString().padLeft(2, '0')}/${initial.date.year}';
    hoursController.text = initial.date.hour.toString().padLeft(2, '0');
    minutesController.text = initial.date.minute.toString().padLeft(2, '0');
    durationController.text = initial.durationMinutes.toString();
    notesController.text = initial.notes;
    _updateCanSave();
  }

  void _addListeners() {
    nameController.addListener(_updateCanSave);
    dateController.addListener(_updateCanSave);
    hoursController.addListener(_updateCanSave);
    minutesController.addListener(_updateCanSave);
    durationController.addListener(_updateCanSave);
  }

  void _updateCanSave() {
    final bool hasTitle = nameController.text.trim().isNotEmpty;
    final bool dateOk = _parseDateTime() != null;
    final int? duration = int.tryParse(durationController.text.trim());
    final bool durationOk = duration != null && duration > 0;

    final bool canSave = hasTitle && dateOk && durationOk;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }
}
