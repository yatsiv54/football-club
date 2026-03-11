import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';

class ScoreBox extends StatelessWidget {
  const ScoreBox({super.key, 
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 48,
      child: CustomTextField(
        controller: controller,
        validator: ValidatorType.score,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}