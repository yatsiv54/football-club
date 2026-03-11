import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class OpenObjectivesButton extends StatelessWidget {
  const OpenObjectivesButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = MyColors.myYellowColor;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 24, child: Image.asset('assets/images/list.png')),
              SizedBox(width: 8),
              Text(
                'OPEN SEASON OBJECTIVES',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: Colors.black),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
