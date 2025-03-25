import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String todoText; // Văn bản công việc cần làm
  
  // Hàm callback onRemove: Được kích hoạt khi nút xóa (với biểu tượng check) được nhấn.
  // Nó cho phép widget cha xử lý việc xóa mục công việc.
  final VoidCallback onRemove; 

  // Hàm callback onEdit: Được kích hoạt khi nút chỉnh sửa (với biểu tượng chỉnh sửa) được nhấn.
  // Nó cho phép widget cha xử lý việc chỉnh sửa mục công việc.
  final VoidCallback onEdit; 

  // Constructor cho lớp TodoItem
  const TodoItem({
    super.key, // Truyền key cho constructor của lớp cha
    required this.todoText, // Khởi tạo thuộc tính todoText với giá trị bắt buộc
    required this.onRemove, // Khởi tạo callback onRemove với giá trị bắt buộc
    required this.onEdit // Khởi tạo callback onEdit với giá trị bắt buộc
  }); 

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
