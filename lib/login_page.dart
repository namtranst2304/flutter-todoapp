import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_list.dart';

class LoginPage extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback toggleMusic;

  const LoginPage({
    super.key,
    required this.isPlaying,
    required this.toggleMusic,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString(_usernameController.text);
    if (storedPassword == _passwordController.text) {
      await prefs.setString('username', _usernameController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TodoList(
            username: _usernameController.text,
            isPlaying: widget.isPlaying,
            toggleMusic: widget.toggleMusic,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  void _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameController.text, _passwordController.text);
    setState(() {
      _isLogin = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful')),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _register();
                Navigator.of(context).pop();
              },
              child: Text('Register'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Hình nền
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLogin ? _login : _register,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () {
                  if (_isLogin) {
                    _showRegisterDialog();
                  } else {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  }
                },
                child: Text(_isLogin ? 'Create an account' : 'Already have an account? Login'),
              ),
              FloatingActionButton(
                onPressed: widget.toggleMusic,
                tooltip: 'Toggle Music',
                child: Icon(widget.isPlaying ? Icons.music_note : Icons.music_off),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
