import 'package:flutter/material.dart';

class CompletedItem extends StatelessWidget {
  final String todoText;       // Văn bản công việc đã hoàn thành
  final VoidCallback onRemove; // Hàm callback để xóa công việc

  const CompletedItem({super.key, required this.todoText, required this.onRemove});  // Constructor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, decoration: TextDecoration.lineThrough, decorationThickness: 2),
        ),              // Hiển thị văn bản công việc
      trailing: IconButton(
        icon: Icon(Icons.delete),         // Icon nút xóa
        onPressed: onRemove,              // Gọi hàm onRemove khi nhấn nút
      ),
    );
  }
}
