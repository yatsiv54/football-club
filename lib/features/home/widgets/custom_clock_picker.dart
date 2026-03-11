import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortuna/features/home/widgets/custom_text_field.dart';

class CustomClockPicker extends StatefulWidget {
  final TextEditingController hoursController;
  final TextEditingController minutesController;
  final ValidatorType hourValidator;
  final ValidatorType minuteValidator;

  const CustomClockPicker({
    super.key,
    required this.hoursController,
    required this.minutesController,
    this.hourValidator = ValidatorType.hour,
    this.minuteValidator = ValidatorType.minute,
  });

  @override
  State<CustomClockPicker> createState() => _CustomClockPickerState();
}

class _CustomClockPickerState extends State<CustomClockPicker> {
  List<TextInputFormatter> get _timeFormatters => [
    LengthLimitingTextInputFormatter(2),
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 68,
          height: 48,
          child: CustomTextField(
            controller: widget.hoursController,
            validator: widget.hourValidator,
            keyboardType: TextInputType.number,
            hint: '00',
            textAlign: TextAlign.center,
            inputFormatters: _timeFormatters,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(':', style: textStyle),
        ),
        SizedBox(
          width: 68,
          height: 48,
          child: CustomTextField(
            controller: widget.minutesController,
            validator: widget.minuteValidator,
            keyboardType: TextInputType.number,
            hint: '00',
            textAlign: TextAlign.center,
            inputFormatters: _timeFormatters,
          ),
        ),
      ],
    );
  }
}
