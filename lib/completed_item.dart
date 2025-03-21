import 'package:flutter/material.dart';

class CompletedItem extends StatelessWidget {
  final String todoText;
  final String completedTime;
  final VoidCallback onRemove;
  final VoidCallback onUndo;

  const CompletedItem({super.key, required this.todoText, required this.completedTime, required this.onRemove, required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, decoration: TextDecoration.lineThrough, decorationThickness: 2),
      ),
      subtitle: Text('Completed at: $completedTime'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: onUndo,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
