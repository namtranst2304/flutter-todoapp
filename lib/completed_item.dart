import 'package:flutter/material.dart';

class CompletedItem extends StatelessWidget {
  final String todoText; // Văn bản công việc đã hoàn thành
  final String completedTime; // Thời gian hoàn thành công việc
  final VoidCallback onRemove; // Hàm callback để xóa công việc
  final VoidCallback onUndo; // Hàm callback để hoàn tác công việc

  // Constructor: Khởi tạo một đối tượng CompletedItem với các tham số bắt buộc
  const CompletedItem({
    super.key, 
    required this.todoText, 
    required this.completedTime, 
    required this.onRemove, 
    required this.onUndo
  }); 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todoText, // Hiển thị văn bản công việc
        style: TextStyle(
          fontSize: 25, // Kích thước chữ là 25
          decoration: TextDecoration.lineThrough, // Gạch ngang chữ để biểu thị công việc đã hoàn thành
          decorationThickness: 2, // Độ dày của đường gạch ngang là 2
        ),
      ),
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
