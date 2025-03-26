import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'login_page.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late final AudioPlayer _player;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _playMusic();
  }

  void _playMusic() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
    } catch (e) {
      // Handle error
    }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        isPlaying: _isPlaying,
        toggleMusic: _toggleMusic,
      ),
    );
  }
}
