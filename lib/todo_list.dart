import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Thư viện âm thanh
import 'package:shared_preferences/shared_preferences.dart'; // Thêm SharedPreferences
import 'todo_item.dart';       // Import widget TodoItem
import 'completed_item.dart';  // Import widget CompletedItem

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();  // Tạo đối tượng trạng thái _TodoListState
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];      // Danh sách công việc cần làm
  final List<String> _completedItems = []; // Danh sách công việc đã hoàn thành
  
  // Biến player để phát nhạc
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = true;  // Mặc định bật nhạc

  @override
  void initState() {
    super.initState();
    _loadData(); // Tải dữ liệu đã lưu
    _playMusic(); // Tự động phát nhạc khi khởi động
  }

  // Hàm tải dữ liệu từ SharedPreferences
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems.addAll(prefs.getStringList('todoItems') ?? []);
      _completedItems.addAll(prefs.getStringList('completedItems') ?? []);
    });
  }

  // Hàm lưu dữ liệu vào SharedPreferences
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoItems', _todoItems);
    await prefs.setStringList('completedItems', _completedItems);
  }

  // Hàm tự động phát nhạc
  void _playMusic() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/background.mp3'));
  }

  // Hàm thêm công việc mới
  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
      _saveData(); // Lưu lại danh sách sau khi thêm
    }
  }

  // Hàm đánh dấu công việc là đã hoàn thành
  void _removeTodoItem(int index) {
    setState(() {
      _completedItems.add(_todoItems[index]);  // Chuyển công việc sang danh sách đã hoàn thành
      _todoItems.removeAt(index);              // Xóa khỏi danh sách cần làm
    });
    _saveData(); // Lưu lại danh sách sau khi cập nhật
  }

  // Hộp thoại xác nhận hoàn thành công việc
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

  // Hàm bật/tắt nhạc nền
  void _toggleMusic() async {
    if (_isPlaying) {
      await _player.stop(); // Dừng nhạc
    } else {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Màn hình thêm công việc mới
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

  // Hàm xây dựng danh sách công việc cần làm
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return TodoItem(
          todoText: _todoItems[index],
          onRemove: () => _promptRemoveTodoItem(index),
        );
      },
    );
  }

  // Hàm xây dựng danh sách công việc đã hoàn thành
  Widget _buildCompletedList() {
    return ListView.builder(
      itemCount: _completedItems.length,
      itemBuilder: (context, index) {
        return CompletedItem(
          todoText: _completedItems[index],
          onRemove: () {
            setState(() {
              _completedItems.removeAt(index); // Xóa khỏi danh sách hoàn thành
            });
            _saveData(); // Lưu lại sau khi cập nhật
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TO DO LIST',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 206, 240),
        centerTitle: true,
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
