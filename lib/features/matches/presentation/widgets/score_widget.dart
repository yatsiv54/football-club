import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';

class ScoreWidget extends StatelessWidget {
  final String score;
  const ScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.asset('assets/images/field.png', fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.circular(12),
              color: Color.fromRGBO(49, 135, 16, 0.6),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(overflow: TextOverflow.ellipsis,
                formatScore(score),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(overflow: TextOverflow.ellipsis,
                'Score',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
