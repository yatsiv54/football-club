import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/diary/presentation/widgets/mood_selector.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/diary/data/diary_entity.dart';
import 'package:fortuna/features/diary/data/diary_repository.dart';
import 'package:go_router/go_router.dart';

class AddDiaryPage extends StatefulWidget {
  const AddDiaryPage({super.key, this.initialDiary});

  final DiaryEntity? initialDiary;

  @override
  State<AddDiaryPage> createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  bool _canSave = false;
  Mood? _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
    _prefillIfEditing();
    _addListeners();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.initialDiary != null ? 'EDIT DIARY' : 'ADD DIARY';
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
                      Text('Title',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: 'Enter Title',
                        controller: _titleController,
                        validator: ValidatorType.name,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      const SizedBox(height: 20),
                      Text('Mood',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      MoodSelector(
                        selected: _selectedMood,
                        onChanged: (mood) {
                          setState(() {
                            _selectedMood = mood;
                            _updateCanSave();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Notes',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: 'Enter note',
                        controller: _notesController,
                        height: 160,
                        keyboardType: TextInputType.multiline,
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
    if (!isValid) return;

    if (_selectedMood == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select mood')));
      return;
    }

    final repo = getit<DiaryRepository>();
    if (widget.initialDiary != null) {
      await repo.updateDiary(
        id: widget.initialDiary!.id,
        title: _titleController.text.trim(),
        mood: moodToInt(_selectedMood!),
        notes: _notesController.text.trim(),
      );
    } else {
      await repo.addDiary(
        title: _titleController.text.trim(),
        mood: moodToInt(_selectedMood!),
        notes: _notesController.text.trim(),
      );
    }

    if (!mounted) return;
    context.pop();
  }

  void _prefillIfEditing() {
    final initial = widget.initialDiary;
    if (initial == null) return;

    _titleController.text = initial.title;
    _selectedMood = moodFromInt(initial.mood);
    _notesController.text = initial.notes;
    _updateCanSave();
  }

  void _addListeners() {
    _titleController.addListener(_updateCanSave);
  }

  void _updateCanSave() {
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasMood = _selectedMood != null;
    final canSave = hasTitle && hasMood;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }
}
