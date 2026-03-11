import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:go_router/go_router.dart';

class StatButton extends StatelessWidget {
  const StatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed('stat'),
      child: Container(
        height: double.infinity,
        width: 56,
        color: MyColors.grey2,
        alignment: Alignment.center,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Image.asset('assets/images/home/stat.png', width: 24),
        ),
      ),
    );
  }
}
