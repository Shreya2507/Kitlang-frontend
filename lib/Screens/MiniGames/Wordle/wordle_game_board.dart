import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Wordle/utils/game_provider.dart';

class WordleGameBoard extends StatefulWidget {
  WordleGameBoard(this.game, {super.key});
  WordleGameProvider game;

  @override
  State<WordleGameBoard> createState() => _WordleGameBoardState();
}

class _WordleGameBoardState extends State<WordleGameBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.game.wordleBoard
          .map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: e
                    .map((e) => Container(
                          padding: EdgeInsets.all(16),
                          width: 64,
                          height: 64,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: e.code == 0
                                ? Colors.grey.shade800
                                : e.code == 1
                                    ? Colors.green.shade800
                                    : Colors.amber.shade800,
                          ),
                          child: Center(
                            child: Text(
                              e.letter ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
