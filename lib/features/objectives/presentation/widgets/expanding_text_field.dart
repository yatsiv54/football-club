import 'package:flutter/material.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';

class ExpandingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final ValidatorType validator;
  final ValueChanged<String>? onChanged;
  final int minLines;

  const ExpandingTextField({
    super.key,
    required this.controller,
    required this.validator,
    this.hint,
    this.onChanged,
    this.minLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: getValidator(validator),
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: null,
      onChanged: onChanged,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
