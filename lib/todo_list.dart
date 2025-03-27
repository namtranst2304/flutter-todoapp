import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'audio_controller.dart';
import 'todo_item.dart';
import 'completed_item.dart';

class TodoList extends StatefulWidget {
  final String username;
  final AudioController audioController;

  const TodoList({
    Key? key,
    required this.username,
    required this.audioController,
  }) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];
  final List<Map<String, dynamic>> _completedItems = [];
  late String _username;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _loadData();
  }

  void _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _todoItems.addAll(prefs.getStringList('$_username-todoItems') ?? []);
        _completedItems.addAll((prefs.getStringList('$_username-completedItems') ?? [])
            .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
            .toList());
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('$_username-todoItems', _todoItems);
      await prefs.setStringList('$_username-completedItems',
          _completedItems.map((item) => jsonEncode(item)).toList());
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          audioController: widget.audioController,
        ),
      ),
    );
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
      _saveData();
    }
  }

  void _editTodoItem(int index, String newTask) {
    if (newTask.isNotEmpty) {
      setState(() {
        _todoItems[index] = newTask;
      });
      _saveData();
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _completedItems.add({
        'task': _todoItems[index],
        'completedTime': DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())
      });
      _todoItems.removeAt(index);
    });
    _saveData();
  }

  void _undoCompletedItem(int index) {
    setState(() {
      _todoItems.add(_completedItems[index]['task']);
      _completedItems.removeAt(index);
    });
    _saveData();
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark "${_todoItems[index]}" as done?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Mark as done'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _promptEditTodoItem(int index) {
    TextEditingController controller = TextEditingController(text: _todoItems[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit "${_todoItems[index]}"'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new task'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _editTodoItem(index, controller.text);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Add a new task')),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return TodoItem(
          todoText: _todoItems[index],
          onRemove: () => _promptRemoveTodoItem(index),
          onEdit: () => _promptEditTodoItem(index),
        );
      },
    );
  }

  Widget _buildCompletedList() {
    return ListView.builder(
      itemCount: _completedItems.length,
      itemBuilder: (context, index) {
        return CompletedItem(
          todoText: _completedItems[index]['task'],
          completedTime: _completedItems[index]['completedTime'],
          onRemove: () {
            setState(() {
              _completedItems.removeAt(index);
            });
            _saveData();
          },
          onUndo: () => _undoCompletedItem(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              title: Text(
                'TO DO LIST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 110, 119, 221).withAlpha(51),
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildTodoList()),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Completed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            Expanded(child: _buildCompletedList()),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Nút điều khiển nhạc sử dụng MusicButton từ audio_controller.dart
          MusicButton(audioController: widget.audioController),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _pushAddTodoScreen,
            tooltip: 'Add task',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _logout,
            tooltip: 'Logout',
            child: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
