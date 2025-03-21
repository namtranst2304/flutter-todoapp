import 'package:flutter/material.dart';

// Widget CompletedItem kế thừa từ StatelessWidget
class CompletedItem extends StatelessWidget {
  final String todoText; // Văn bản công việc đã hoàn thành
  final String completedTime; // Thời gian hoàn thành công việc
  final VoidCallback onRemove; // Hàm callback để xóa công việc
  final VoidCallback onUndo; // Hàm callback để hoàn tác công việc

  const CompletedItem({super.key, required this.todoText, required this.completedTime, required this.onRemove, required this.onUndo}); // Constructor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(fontSize: 25, decoration: TextDecoration.lineThrough, decorationThickness: 2),
      ), // Hiển thị văn bản công việc
      subtitle: Text('Completed at: $completedTime'), // Hiển thị thời gian hoàn thành
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.undo), // Icon nút hoàn tác
            onPressed: onUndo, // Gọi hàm onUndo khi nhấn nút
          ),
          IconButton(
            icon: Icon(Icons.delete), // Icon nút xóa
            onPressed: onRemove, // Gọi hàm onRemove khi nhấn nút
          ),
        ],
      ),
    );
  }
}
