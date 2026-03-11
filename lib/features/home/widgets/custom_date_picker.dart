import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final ValidatorType validatorType;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.validatorType,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: CustomTextField(
          hint: 'dd/mm/yyyy',
          readOnly: true,
          controller: widget.controller,
          validator: widget.validatorType,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final fallbackNow = DateTime.now();
    final firstDate = widget.firstDate ?? fallbackNow;
    final lastDate = widget.lastDate ?? DateTime(2100);

    DateTime initial = selectedDate ??
        widget.initialDate ??
        fallbackNow;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: MyColors.myYellowColor,
              surface: MyColors.myBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }
}
