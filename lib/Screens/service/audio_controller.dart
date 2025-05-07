import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioController with ChangeNotifier {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;

  AudioController._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;

  String? _currentTrackPath;

  bool get isPlaying => _isPlaying;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _player.setLoopMode(LoopMode.one);
      _player.setVolume(0.6);
      _player.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        notifyListeners();
      });
      _isInitialized = true;
    }
  }

  Future<void> playTrack(String trackPath) async {
    await initialize();

    if (_currentTrackPath != trackPath) {
      _currentTrackPath = trackPath;
      await _player.setAsset(trackPath);
      await _player.play();
    } else if (!_isPlaying) {
    
      await _player.play();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
