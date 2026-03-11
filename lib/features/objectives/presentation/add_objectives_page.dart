import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/di.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:fortuna/features/home/widgets/custom_date_picker.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';
import 'package:fortuna/features/layout/widgets/back_button.dart';
import 'package:fortuna/features/layout/widgets/custom_appbar.dart';
import 'package:fortuna/features/objectives/data/objective_entity.dart';
import 'package:fortuna/features/objectives/data/objectives_repository.dart';
import 'package:fortuna/features/objectives/presentation/widgets/category_selector.dart';
import 'package:fortuna/features/objectives/presentation/widgets/goal_type_selector.dart';
import 'package:fortuna/features/objectives/presentation/widgets/expanding_text_field.dart';
import 'package:fortuna/features/objectives/presentation/widgets/steps_editor.dart';
import 'package:go_router/go_router.dart';

class AddObjectivesPage extends StatefulWidget {
  const AddObjectivesPage({super.key, this.initialObjective});

  final ObjectiveEntity? initialObjective;

  @override
  State<AddObjectivesPage> createState() => _AddObjectivesPageState();
}

class _AddObjectivesPageState extends State<AddObjectivesPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _deadlineController;
  final List<StepField> _stepFields = [];
  ObjectiveCategory? _selectedCategory;
  GoalType _goalType = GoalType.simple;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _deadlineController = TextEditingController();
    _prefill();
    _addListeners();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    for (final f in _stepFields) {
      f.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.initialObjective == null
            ? 'ADD OBJECTIVE'
            : 'EDIT OBJECTIVE',
        leading: const LayoutBackButton(),
      ),
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
                        'Title',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        validator: ValidatorType.name,
                        hint: 'Enter objective name',
                        controller: _titleController,
                        onChanged: (_) => _updateCanSave(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      CategorySelector(
                        selected: _selectedCategory,
                        onChanged: (c) {
                          setState(() {
                            _selectedCategory = c;
                            _updateCanSave();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      ExpandingTextField(
                        hint:
                            'Describe your goal, requirements, methods, or purpose…',
                        controller: _descriptionController,
                        validator: ValidatorType.notes,
                        minLines: 3,
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Deadline',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      CustomDatePicker(
                        controller: _deadlineController,
                        validatorType: ValidatorType.date,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Goal Type',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      GoalTypeSelector(
                        selected: _goalType,
                        onChanged: (type) {
                          setState(() {
                            _goalType = type;
                          });
                        },
                      ),
                      if (_goalType == GoalType.stepBased) ...[
                        const SizedBox(height: 20),
                        StepsEditor(
                          fields: _stepFields,
                          onAddStep: _addStep,
                          onChanged: _updateCanSave,
                        ),
                      ],
                      const SizedBox(height: 20),
                      CustomSaveButton(onPressed: _onSave, enabled: _canSave),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addListeners() {
    _titleController.addListener(_updateCanSave);
    _deadlineController.addListener(_updateCanSave);
  }

  void _updateCanSave() {
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasCategory = _selectedCategory != null;
    final deadlineOk =
        _deadlineController.text.trim().isEmpty || _parseDeadline() != null;
    final canSave = hasTitle && hasCategory && deadlineOk;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }

  DateTime? _parseDeadline() {
    final text = _deadlineController.text.trim();
    if (text.isEmpty) return null;
    final parts = text.split(RegExp(r'[./]'));
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  Future<void> _onSave() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a category')));
      return;
    }
    final deadline = _parseDeadline();
    final repo = getit<ObjectivesRepository>();
    final Map<String, bool> steps = _goalType == GoalType.stepBased
        ? _collectSteps()
        : <String, bool>{};

    if (widget.initialObjective == null) {
      await repo.addObjective(
        title: _titleController.text.trim(),
        status: ObjectiveStatus.active,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        deadline: deadline,
        goalType: _goalType,
        steps: steps,
      );
    } else {
      await repo.updateObjective(
        id: widget.initialObjective!.id,
        title: _titleController.text.trim(),
        status: widget.initialObjective!.status,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        deadline: deadline,
        goalType: _goalType,
        steps: steps,
      );
    }
    if (!mounted) return;
    context.pop();
  }

  void _addStep() {
    setState(() {
      _stepFields.add(StepField(controller: TextEditingController()));
    });
  }

  Map<String, bool> _collectSteps() {
    final Map<String, bool> steps = {};
    for (final field in _stepFields) {
      final text = field.controller.text.trim();
      if (text.isEmpty) continue;
      steps[text] = field.done;
    }
    return steps;
  }

  void _prefill() {
    final initial = widget.initialObjective;
    if (initial == null) {
      _addStep();
      return;
    }
    _titleController.text = initial.title;
    _descriptionController.text = initial.description;
    if (initial.deadline != null) {
      final d = initial.deadline!;
      _deadlineController.text =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
    _selectedCategory = initial.category;
    _goalType = initial.goalType;
    if (initial.goalType == GoalType.stepBased && initial.steps.isNotEmpty) {
      for (final entry in initial.steps.entries) {
        _stepFields.add(
          StepField(
            controller: TextEditingController(text: entry.key),
            done: entry.value,
          ),
        );
      }
    } else {
      _addStep();
    }
    _updateCanSave();
  }
}
