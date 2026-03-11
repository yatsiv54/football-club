import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';

class StepField {
  final TextEditingController controller;
  bool done;
  StepField({required this.controller, this.done = false});
}

class StepsEditor extends StatelessWidget {
  final List<StepField> fields;
  final VoidCallback onAddStep;
  final VoidCallback? onChanged;
  const StepsEditor({
    super.key,
    required this.fields,
    required this.onAddStep,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          ...List.generate(
            fields.length,
            (i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(overflow: TextOverflow.ellipsis,
                  'Step ${i + 1}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomTextField(
                  controller: fields[i].controller,
                  validator: ValidatorType.notes,
                  hint: 'Enter step description',
                  height: 48,
                  onChanged: (_) => onChanged?.call(),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAddStep,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: MyColors.myYellowColor, size: 25),
                const SizedBox(width: 8),
                Text(overflow: TextOverflow.ellipsis,
                  'Add Step',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MyColors.myYellowColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
