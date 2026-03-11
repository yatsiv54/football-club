import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/home/widgets/custom_date_picker.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/squad/data/player_entity.dart';
import 'package:fortuna/features/squad/data/players_repository.dart';
import 'package:fortuna/features/squad/presentation/widgets/position_selector.dart';
import 'package:go_router/go_router.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key, this.initialPlayer});

  final PlayerEntity? initialPlayer;

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController dateController;
  late final TextEditingController jerseyNumberController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController notesController;
  String? _selectedPosition;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dateController = TextEditingController();
    jerseyNumberController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    notesController = TextEditingController();
    _prefillIfEditing();
    _addListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    jerseyNumberController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.initialPlayer != null
        ? 'EDIT PLAYER'
        : 'ADD PLAYER';
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
                        'Full Name',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: 'Enter player name',
                        controller: nameController,
                        validator: ValidatorType.name,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text('Position',
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 8),
                      PositionSelector(
                        selected: _selectedPosition,
                        onChanged: (pos) {
                          setState(() {
                            _selectedPosition = pos;
                            _updateCanSave();
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Jersey Number',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: 'Number',
                        keyboardType:
                            const TextInputType.numberWithOptions(),
                        controller: jerseyNumberController,
                        validator: ValidatorType.notes,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Date of birth',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      CustomDatePicker(
                        controller: dateController,
                        validatorType: ValidatorType.date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        initialDate: widget.initialPlayer?.dob,
                      ),
                      SizedBox(height: 20),
                      Text('Phone',
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: '+000 000 000 000',
                        keyboardType:
                            const TextInputType.numberWithOptions(),
                        controller: phoneNumberController,
                        validator: ValidatorType.phoneNumber,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text('Email',
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: 'example@email.com',
                       keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: ValidatorType.email,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      SizedBox(height: 20),
                      Text('Notes',
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        keyboardType: TextInputType.multiline,
                        hint: 'Enter note',
                        height: 160,
                        controller: notesController,
                        validator: ValidatorType.notes,
                      ),
                      SizedBox(height: 20),
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
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose position!')),
      );
      return;
    }
    final DateTime? dob = _parseDob();
    if (dateController.text.isNotEmpty && dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid date of birth')),
      );
      return;
    }

    final int? jerseyNumber = jerseyNumberController.text.trim().isEmpty
        ? null
        : int.tryParse(jerseyNumberController.text.trim());
    if (jerseyNumberController.text.trim().isNotEmpty && jerseyNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid jersey number')),
      );
      return;
    }

    final repo = getit<PlayersRepository>();

    if (widget.initialPlayer != null) {
      await repo.updatePlayer(
        id: widget.initialPlayer!.id,
        name: nameController.text.trim(),
        position: _selectedPosition!,
        jerseyNumber: jerseyNumber,
        dob: dob,
        phoneNumber: phoneNumberController.text.trim(),
        email: emailController.text.trim(),
        note: notesController.text.trim(),
      );
    } else {
      await repo.addPlayer(
        name: nameController.text.trim(),
        position: _selectedPosition!,
        jerseyNumber: jerseyNumber,
        dob: dob,
        phoneNumber: phoneNumberController.text.trim(),
        email: emailController.text.trim(),
        note: notesController.text.trim(),
      );
    }

    if (!mounted) return;
    context.pop();
  }

  DateTime? _parseDob() {
    final dateParts = dateController.text.split(RegExp(r'[./]'));
    if (dateParts.length != 3 || dateController.text.trim().isEmpty) {
      return null;
    }

    final int? day = int.tryParse(dateParts[0]);
    final int? month = int.tryParse(dateParts[1]);
    final int? year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  void _prefillIfEditing() {
    final initial = widget.initialPlayer;
    if (initial == null) return;

    nameController.text = initial.name;
    _selectedPosition = initial.position;
    if (initial.dob != null) {
      dateController.text =
          '${initial.dob!.day.toString().padLeft(2, '0')}/${initial.dob!.month.toString().padLeft(2, '0')}/${initial.dob!.year}';
    }
    if (initial.jerseyNumber != null) {
      jerseyNumberController.text = initial.jerseyNumber.toString();
    }
    phoneNumberController.text = initial.phoneNumber;
    emailController.text = initial.email;
    notesController.text = initial.note;
    _updateCanSave();
  }

  void _addListeners() {
    nameController.addListener(_updateCanSave);
    dateController.addListener(_updateCanSave);
    jerseyNumberController.addListener(_updateCanSave);
    phoneNumberController.addListener(_updateCanSave);
    emailController.addListener(_updateCanSave);
  }

  void _updateCanSave() {
    final bool hasName = nameController.text.trim().isNotEmpty;
    final bool hasPosition = _selectedPosition != null;
    final bool dateOk = dateController.text.isEmpty
        ? true
        : _parseDob() != null;
    final bool jerseyOk = jerseyNumberController.text.trim().isEmpty
        ? true
        : int.tryParse(jerseyNumberController.text.trim()) != null;

    final bool canSave = hasName && hasPosition && dateOk && jerseyOk;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }
}
