import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'todo_item.dart';
import 'completed_item.dart';
import 'dart:ui';
import 'dart:convert';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];
  final List<Map<String, dynamic>> _completedItems = [];
  late final AudioPlayer _player;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadData();
    _playMusic();
  }

  void _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _todoItems.addAll(prefs.getStringList('todoItems') ?? []);
        _completedItems.addAll((prefs.getStringList('completedItems') ?? []).map((item) => Map<String, dynamic>.from(jsonDecode(item))).toList());
      });
    } catch (e) {
      // Handle error
    }
  }

  void _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('todoItems', _todoItems);
      await prefs.setStringList('completedItems', _completedItems.map((item) => jsonEncode(item)).toList());
    } catch (e) {
      // Handle error
    }
  }

  void _playMusic() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
    } catch (e) {
      // Handle error
    }
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

  void _toggleMusic() async {
    if (_isPlaying) {
      await _player.stop();
    } else {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
            ),
            Expanded(child: _buildCompletedList()),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleMusic,
            tooltip: 'Toggle Music',
            child: Icon(_isPlaying ? Icons.music_off : Icons.music_note),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _pushAddTodoScreen,
            tooltip: 'Add task',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}