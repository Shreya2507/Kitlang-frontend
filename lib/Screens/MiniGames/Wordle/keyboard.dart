import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Wordle/utils/game_provider.dart';
import 'package:frontend/Screens/MiniGames/Wordle/wordle_game_board.dart';

class Keyboard extends StatefulWidget {
  Keyboard(this.game, {super.key});
  WordleGameProvider game;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  List row1 = "qwertyuiop".toUpperCase().split("");
  List row2 = "asdfghjkl".toUpperCase().split("");
  List row3 = ["Z", "X", "C", "V", "B", "N", "M"];
  List row4 = ["DEL", "SUBMIT"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          WordleGameProvider.gameMessage,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        WordleGameBoard(widget.game),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row1.map((e) {
            return InkWell(
              onTap: () {
                print(e);

                //game logic
                if (widget.game.letterId < 5) {
                  setState(() {
                    widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                    widget.game.letterId++;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 33,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "$e",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row2.map((e) {
            return InkWell(
              onTap: () {
                print(e);

                //game logic
                if (widget.game.letterId < 5) {
                  setState(() {
                    widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                    widget.game.letterId++;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 33,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "$e",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row3.map((e) {
            return InkWell(
              onTap: () {
                print(e);

                //game logic
                if (widget.game.letterId < 5) {
                  setState(() {
                    widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                    widget.game.letterId++;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 33,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "$e",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: row4.map((e) {
            return InkWell(
              onTap: () {
                print(e);

                //game logic
                if (e == "DEL") {
                  if (widget.game.letterId > 0) {
                    setState(() {
                      widget.game.insertWord(
                          (widget.game.letterId - 1), Letter("", 0));
                      widget.game.letterId--;
                    });
                  }
                } else if (e == "SUBMIT") {
                  if (widget.game.letterId == 5) {
                    // Ensure exactly 5 letters are entered
                    String guess = widget.game.wordleBoard[widget.game.rowId]
                        .map((e) => e.letter)
                        .join();

                    widget.game.checkWordExist(guess).then((exists) {
                      if (exists) {
                        List<String> wordList =
                            WordleGameProvider.gameGuess.split("");
                        List<String> guessList = guess.split("");
                        List<bool> correctPositions = List.filled(5, false);

                        // First pass: Mark correctly placed letters (Green)
                        for (int i = 0; i < 5; i++) {
                          if (guessList[i] == wordList[i]) {
                            widget.game.wordleBoard[widget.game.rowId][i].code =
                                1;
                            correctPositions[i] = true;
                            wordList[i] =
                                "_"; // Remove used letter to prevent double matching
                          }
                        }

                        // Second pass: Mark misplaced letters (Yellow)
                        for (int i = 0; i < 5; i++) {
                          if (!correctPositions[i] &&
                              wordList.contains(guessList[i])) {
                            widget.game.wordleBoard[widget.game.rowId][i].code =
                                2;
                            wordList[wordList.indexOf(guessList[i])] =
                                "_"; // Remove used letter
                          }
                        }

                        // Check if player won
                        if (guess == WordleGameProvider.gameGuess) {
                          setState(() {
                            WordleGameProvider.gameMessage =
                                "🎉 Congratulations! You guessed it!";
                            WordleGameProvider.gameOver = true;
                          });
                        } else {
                          setState(() {
                            widget.game.rowId++;
                            widget.game.letterId = 0;
                            if (widget.game.rowId >= 5) {
                              WordleGameProvider.gameMessage =
                                  "Game Over! The word was: ${WordleGameProvider.gameGuess}";
                              WordleGameProvider.gameOver = true;
                            }
                          });
                        }
                      } else {
                        setState(() {
                          WordleGameProvider.gameMessage =
                              "❌ Invalid word. Try again!";
                        });
                      }
                    }).catchError((error) {
                      setState(() {
                        WordleGameProvider.gameMessage =
                            "❌ Error checking word!";
                      });
                    });
                  } else {
                    print("Enter all 5 letters before submitting.");
                  }
                }
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "$e",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
