import 'package:flutter/material.dart';
import 'audio_controller.dart';
import 'login_page.dart';
import 'todo_list.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  final AudioController _audioController = AudioController();

  TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      //initialRoute: '/loginpage',
      home: LoginPage(audioController: _audioController),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/loginpage':
            return MaterialPageRoute(
              builder: (context) =>
                  LoginPage(audioController: _audioController),
            );
          case '/todopage':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('username')) {
              return MaterialPageRoute(
                builder: (context) => TodoList(
                  username: args['username'],
                  audioController: _audioController,
                ),
              );
            }
            // Nếu không có args hợp lệ, chuyển về trang login
            return MaterialPageRoute(
              builder: (context) =>
                  LoginPage(audioController: _audioController),
            );
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  LoginPage(audioController: _audioController),
            );
        }
      },
    );
  }
}
