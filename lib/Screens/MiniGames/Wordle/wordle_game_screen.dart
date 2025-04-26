import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Wordle/keyboard.dart';
import 'package:frontend/Screens/MiniGames/Wordle/utils/game_provider.dart';

class WordleGame extends StatefulWidget {
  WordleGame({super.key});

  @override
  State<WordleGame> createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  WordleGameProvider _game = WordleGameProvider();

  @override
  void initState() {
    super.initState();
    _game.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1, 45, 45, 45),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Wordle",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Keyboard(_game),
        ],
      ),
    );
  }
}
