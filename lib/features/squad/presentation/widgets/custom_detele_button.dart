import 'package:flutter/material.dart';

class CustomDeleteButton extends StatelessWidget {
  final Future<void> Function() onTap;
  final Object toDelete;
  const CustomDeleteButton({
    super.key,
    required this.onTap,
    required this.toDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirm delete'),
            content: Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await onTap();
        }
      },
      child: Container(
        width: 120,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Color.fromRGBO(230, 0, 0, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Image.asset('assets/images/squad/delete.png'),
              ),
              const Spacer(),
              Text(overflow: TextOverflow.ellipsis,
                'Delete',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: const Color.fromRGBO(230, 0, 0, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _itemLabel(Object toDelete) {
  try {
    final dynamic item = toDelete;
    if (item.name is String && (item.name as String).isNotEmpty) {
      return item.name as String;
    }
    if (item.title is String && (item.title as String).isNotEmpty) {
      return item.title as String;
    }
  } catch (_) {}
  return toDelete.toString();
}
