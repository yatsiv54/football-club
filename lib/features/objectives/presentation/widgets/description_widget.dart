import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class ObjectiveDescriptionWidget extends StatelessWidget {
  final String description;
  const ObjectiveDescriptionWidget({super.key, this.description = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyColors.grey3,
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description'),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.grey4,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(12),
              child: Text(overflow: TextOverflow.ellipsis,
                description == '' ? 'No description' : description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
