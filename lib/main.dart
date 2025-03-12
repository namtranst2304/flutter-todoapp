// Import thư viện Flutter
import 'package:flutter/material.dart';
// Import widget TodoList từ tệp todo_list.dart
import 'todo_list.dart';

// Hàm main khởi chạy ứng dụng Flutter
void main() => runApp(TodoApp());

// Widget TodoApp kế thừa từ StatelessWidget
class TodoApp extends StatelessWidget {
    const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Trả về một MaterialApp với tiêu đề và widget TodoList
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}
