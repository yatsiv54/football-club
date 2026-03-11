import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class FocusWidget extends StatelessWidget {
  final String title;
  const FocusWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: MyColors.grey3,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Center(
        child: Text(
          maxLines: 5,
          title,
          style: Theme.of(context).textTheme.displayLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
