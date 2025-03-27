import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = true;

  AudioController() {
    _initialize();
  }

  void _initialize() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  bool get isPlaying => _isPlaying;

  Future<void> toggleMusic() async {
    if (_isPlaying) {
      await _player.stop();
    } else {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background.mp3'));
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }
}

class MusicButton extends StatelessWidget {
  final AudioController audioController;
  const MusicButton({Key? key, required this.audioController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: audioController,
      builder: (context, child) {
        return IconButton(
          icon: Icon(
            audioController.isPlaying ? Icons.music_note : Icons.music_off,
            size: 30,
          ),
          onPressed: () {
            audioController.toggleMusic();
          },
        );
      },
    );
  }
}
