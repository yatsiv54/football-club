import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        width: 56,
        color: MyColors.grey2,
        child: SizedBox(
          width: 24,
          child: Image.asset('assets/images/home/edit.png'),
        ),
      ),
    );
  }
}
