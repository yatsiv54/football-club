import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class LayoutNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LayoutNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: MyColors.grey2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem( 
            index: 0,
            current: currentIndex,
            icon: 'assets/images/nav/home.png',
            label: "Schedule",
            onTap: onTap,
          ),
          _NavItem(
            index: 1,
            current: currentIndex,
            icon: 'assets/images/nav/football.png',
            label: "Training",
            onTap: onTap,
          ),
          _NavItem(
            index: 2,
            current: currentIndex,
            icon: 'assets/images/nav/squad.png',
            label: "Squad",
            onTap: onTap,
          ),
          _NavItem(
            index: 3,
            current: currentIndex,
            icon: 'assets/images/nav/diary.png',
            label: "Diary",
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int current;
  final String icon;
  final String label;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = index == current;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? MyColors.grey3 : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24, child: Image.asset(icon)),
            const SizedBox(height: 6),
            Text(
              overflow: TextOverflow.ellipsis,
              label,
              style: selected
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
