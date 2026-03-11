import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';

class NotesWidget extends StatelessWidget {
  final String notes;
  const NotesWidget({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes'),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                color: MyColors.grey3,
                border: BoxBorder.all(color: MyColors.grey4, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  notes == '' ? 'No notes' : notes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
