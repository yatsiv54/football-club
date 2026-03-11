import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class MoodSelector extends StatefulWidget {
  final Mood? selected;
  final ValueChanged<Mood> onChanged;
  const MoodSelector({super.key, required this.onChanged, this.selected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  late Mood? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3.2,
      children: Mood.values.map((mood) {
        return _MoodChip(
          mood: mood,
          selected: _current == mood,
          onTap: () {
            setState(() => _current = mood);
            widget.onChanged(mood);
          },
        );
      }).toList(),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final Mood mood;
  final bool selected;
  final VoidCallback onTap;

  const _MoodChip({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = moodMap[mood]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.grey3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? data.color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24, child: Image.asset(data.icon)),
            const SizedBox(width: 8),
            Text(overflow: TextOverflow.ellipsis,
              data.title,
              style: TextStyle(color: data.color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

enum Mood { motivated, good, tired, focused, neutral }

class MoodData {
  final String title;
  final String icon;
  final Color color;

  const MoodData(this.title, this.icon, this.color);
}

final moodMap = {
  Mood.motivated: MoodData(
    'Motivated',
    'assets/images/diary/motivated.png',
    Color.fromRGBO(255, 153, 0, 1),
  ),
  Mood.good: MoodData(
    'Good',
    'assets/images/diary/good.png',
    MyColors.myYellowColor,
  ),
  Mood.tired: MoodData(
    'Tired',
    'assets/images/diary/tired.png',
    Color.fromRGBO(0, 178, 255, 1),
  ),
  Mood.focused: MoodData(
    'Focused',
    'assets/images/diary/focused.png',
    Color.fromRGBO(255, 153, 0, 1),
  ),
  Mood.neutral: MoodData(
    'Neutral',
    'assets/images/diary/neutral.png',
    MyColors.myYellowColor,
  ),
};

int moodToInt(Mood mood) => mood.index + 1;

Mood moodFromInt(int value) {
  final idx = (value - 1).clamp(0, Mood.values.length - 1);
  return Mood.values[idx];
}
