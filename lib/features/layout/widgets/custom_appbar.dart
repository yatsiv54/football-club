import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.action,
    this.leading,
  });

  final Widget? action;
  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      leadingWidth: 56,
      titleSpacing: 0,
      actions: action != null ? [action!] : const [],
      toolbarHeight: 64,
      centerTitle: true,
      title: Text(title, style: Theme.of(context).textTheme.titleLarge,overflow: TextOverflow.ellipsis,),
      backgroundColor: MyColors.myYellowColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
