import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String todoText;       // Văn bản công việc cần làm
  final VoidCallback onRemove; // Hàm callback để xóa công việc

  const TodoItem({super.key, required this.todoText, required this.onRemove});  // Constructor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),              // Hiển thị văn bản công việc
      trailing: IconButton(
        icon: Icon(Icons.check),          // Icon nút check
        onPressed: onRemove,              // Gọi hàm onRemove khi nhấn nút
      ),
    );
  }
}
