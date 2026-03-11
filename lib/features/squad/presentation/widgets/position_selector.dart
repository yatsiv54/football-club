import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class PositionSelector extends StatefulWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const PositionSelector({super.key, this.selected, required this.onChanged});

  @override
  State<PositionSelector> createState() => _PositionSelectorState();
}

class _PositionSelectorState extends State<PositionSelector> {
  String? current;

  @override
  void initState() {
    super.initState();
    current = widget.selected;
  }

  void select(String pos) {
    setState(() => current = pos);
    widget.onChanged(pos);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: _PositionChip(
              position: 'GK',
              isSelected: current == 'GK',
              onTap: select,
            ),
          ),
          Expanded(
            child: _PositionChip(
              position: 'DF',
              isSelected: current == 'DF',
              onTap: select,
            ),
          ),
          Expanded(
            child: _PositionChip(
              position: 'MF',
              isSelected: current == 'MF',
              onTap: select,
            ),
          ),
          Expanded(
            child: _PositionChip(
              position: 'FW',
              isSelected: current == 'FW',
              onTap: select,
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionChip extends StatelessWidget {
  final String position;
  final bool isSelected;
  final ValueChanged<String> onTap;

  const _PositionChip({
    required this.position,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(position),
      child: Container(
        height: 49,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? MyColors.myYellowColor : MyColors.grey3,
        ),
        child: Center(
          child: Text(overflow: TextOverflow.ellipsis,
            position,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
