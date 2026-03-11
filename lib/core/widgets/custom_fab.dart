import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:go_router/go_router.dart';

enum ButtonType { matches, training, squad, diary, objectives }

class CustomFab extends StatelessWidget {
  const CustomFab({super.key, required this.type});
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      
      heroTag: null,
      backgroundColor: MyColors.myYellowColor,
      shape: CircleBorder(),
      onPressed: _onTapHelper(type, context),
      child: Icon(Icons.add, size: 25),
    );
  }
}

VoidCallback _onTapHelper(ButtonType type, BuildContext context) {
  switch (type) {
    case ButtonType.matches:
      return () => context.push('/home/addmatch');
    case ButtonType.training:
      return () => context.push('/training/addtraining');
    case ButtonType.squad:
      return () => context.push('/squad/addplayer');
    case ButtonType.diary:
      return () => context.push('/diary/adddiary');
    case ButtonType.objectives:
      return () => context.push('/objectives/addobjective');
  }
}
