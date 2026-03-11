import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class LayoutBackButton extends StatelessWidget {
  const LayoutBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        height: double.infinity,
        width: 56,
        color: MyColors.grey2,
        child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
      ),
    );
  }
}
