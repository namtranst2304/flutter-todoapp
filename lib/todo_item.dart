import 'package:flutter/material.dart';

// Widget TodoItem kế thừa từ StatelessWidget
class TodoItem extends StatelessWidget {
  final String todoText; // Văn bản công việc cần làm
  final VoidCallback onRemove; // Hàm callback để xóa công việc
  final VoidCallback onEdit; // Hàm callback để chỉnh sửa công việc

  const TodoItem({super.key, required this.todoText, required this.onRemove, required this.onEdit}); // Constructor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ), // Hiển thị văn bản công việc
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit), // Icon nút chỉnh sửa
            onPressed: onEdit, // Gọi hàm onEdit khi nhấn nút
          ),
          IconButton(
            icon: Icon(Icons.check), // Icon nút check
            onPressed: onRemove, // Gọi hàm onRemove khi nhấn nút
          ),
        ],
      ),
    );
  }
}
