import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class CustomSaveButton extends StatelessWidget {
  const CustomSaveButton({
    this.title = 'Save',
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = enabled
        ? MyColors.myYellowColor
        : MyColors.myYellowColor.withValues(alpha: 0.4);

    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
