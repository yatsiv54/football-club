import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ValidatorType {
  name,
  date,
  hour,
  minute,
  location,
  notes,
  score,
  number,
  phoneNumber,
  email,
}

class CustomTextField extends StatelessWidget {
  final double height;
  final bool readOnly;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final ValidatorType validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.hint,
    required this.controller,
    this.height = 48,
    this.keyboardType,
    required this.validator,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.onChanged,
  });

  bool get _isMultiline =>
      height > 48 || keyboardType == TextInputType.multiline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        readOnly: readOnly,
        validator: getValidator(validator),
        controller: controller,
        keyboardType: _isMultiline ? TextInputType.multiline : keyboardType,
        textAlign: textAlign,
        textAlignVertical: _isMultiline
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        inputFormatters: inputFormatters,
        expands: _isMultiline,
        minLines: _isMultiline ? null : 1,
        maxLines: _isMultiline ? null : 1,
        onChanged: onChanged,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

FormFieldValidator<String> getValidator(ValidatorType type) {
  switch (type) {
    case ValidatorType.name:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field';
        }
        return null;
      };
    case ValidatorType.date:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Enter date';
        }
        return null;
      };
    case ValidatorType.hour:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field';
        }
        final int? hours = int.tryParse(value);
        if (hours == null || hours < 0 || hours > 23) {
          return '0-23';
        }
        return null;
      };
    case ValidatorType.minute:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field';
        }
        final int? minutes = int.tryParse(value);
        if (minutes == null || minutes < 0 || minutes > 59) {
          return '0-59';
        }
        return null;
      };
    case ValidatorType.location:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field';
        }
        return null;
      };
    case ValidatorType.notes:
      return (value) {
        return null;
      };
    case ValidatorType.score:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Enter score';
        }
        final int? number = int.tryParse(value);
        if (number == null || number < 0 || number > 99) {
          return '0-99';
        }
        return null;
      };
    case ValidatorType.number:
      return (value) {
        if (value == null || value.isEmpty) {
          return 'asd';
        }
        final int? number = int.tryParse(value);
        if (number == null || number < 0 || number > 99) {
          return '0-99';
        }
        return null;
      };
    case ValidatorType.phoneNumber:
      return (value) {
        if (value == null || value.trim().isEmpty) {
          return '';
        }

        final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

        final phoneRegex = RegExp(r'^\d{8,15}$');

        if (!phoneRegex.hasMatch(cleaned)) {
          return '';
        }

        return null;
      };
    case ValidatorType.email:
      return (value) {
        if (value == null || value.trim().isEmpty) {
          return '';
        }

        final email = value.trim();

        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );

        if (!emailRegex.hasMatch(email)) {
          return '';
        }

        return null;
      };
  }
}
