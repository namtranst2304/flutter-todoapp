import 'package:flutter/material.dart';
import 'todo_list.dart';

// Hàm main khởi chạy ứng dụng Flutter
void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key}); // super.key truyền key từ TodoApp đến lớp cha StatelessWidget

  @override
  Widget build(BuildContext context) {
    /*
     * Trả về một MaterialApp với tiêu đề và widget TodoList
     * MaterialApp là widget gốc của ứng dụng, cung cấp nhiều tính năng như điều hướng, chủ đề, và nhiều hơn nữa.
     * debugShowCheckedModeBanner: false để ẩn banner debug.
     * home: TodoList() đặt TodoList làm widget chính của ứng dụng.
     */
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}

/*
 * Truyền key là việc cung cấp một giá trị key cho widget.
 * Key giúp Flutter xác định và theo dõi trạng thái của widget khi cấu trúc widget thay đổi.
 * Khi truyền super.key, key được truyền từ TodoApp đến lớp cha StatelessWidget.
 */
