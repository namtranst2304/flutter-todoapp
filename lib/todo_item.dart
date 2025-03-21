import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String todoText;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const TodoItem({super.key, required this.todoText, required this.onRemove, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
