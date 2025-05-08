import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Hangman/game/figure.dart';
import 'package:frontend/Screens/MiniGames/Hangman/game/hidden_letters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameScreen extends StatefulWidget {
  final String level;
  final bool reveal;

  const GameScreen({super.key, required this.level, required this.reveal});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isLoading = true;
  var alphabets = "abcdefghijklmnopqrstuvwxyz ,'".toUpperCase();
  List<String> selectedChar = [];
  var tries = 0;
  Set<int> revealedIndices = {};

  List<dynamic> gameWords = [];
  int currentWordIndex = 0;
  String translatedWord = '';
  String definition = '';
  String example = '';
  int score = 0;
  // Create a Random object
  final random = Random();

  final String baseUrl =
      'https://saran-2021-api-gateway.hf.space/api/kitlang/word-game/words';

  @override
  void initState() {
    super.initState();
    fetchGameWords();
  }

  Future<void> fetchGameWords() async {
    int randomchap = 1 + random.nextInt(15);
    int randomtop = 1 + random.nextInt(5);
    setState(() {
      isLoading = true;
      selectedChar = [];
      tries = 0;
      revealedIndices.clear();
      currentWordIndex = 0;
      score = 0;
    });

    final url = Uri.parse('$baseUrl/1/1/german');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          gameWords = data['game_content'];
          if (gameWords.isNotEmpty) {
            _loadCurrentWord();
          }
          isLoading = false;
        });
      } else {
        setState(() {
          translatedWord = 'Error loading words';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        translatedWord = 'Failed to connect to server';
        isLoading = false;
      });
    }
  }

  void _loadCurrentWord() {
    if (currentWordIndex < gameWords.length) {
      setState(() {
        selectedChar = [];
        tries = 0;
        revealedIndices.clear();
        translatedWord =
            gameWords[currentWordIndex]['word'].toString().toUpperCase();
        definition = gameWords[currentWordIndex]['meaning'].toString();
        example = gameWords[currentWordIndex]['example'].toString();
      });
      _revealInitialLetters();
    }
  }

  void _revealInitialLetters() {
    if (widget.reveal) {
      if (translatedWord.length >= 2) {
        while (revealedIndices.length < 2) {
          revealedIndices.add(Random().nextInt(translatedWord.length));
        }
      } else {
        revealedIndices.add(0);
      }
    }
  }

  void _resetGame() {
    fetchGameWords();
  }

  void _showGameOverModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over!"),
          content: Text("The word was: $translatedWord"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void _checkWinCondition() {
    List<String> revealedLetters = revealedIndices
        .map((index) => translatedWord[index].toUpperCase())
        .toList();

    bool allCorrect = translatedWord.split("").asMap().entries.every((entry) {
      int index = entry.key;
      String letter = entry.value.toUpperCase();

      if (revealedIndices.contains(index)) {
        return true;
      } else {
        return selectedChar.contains(letter);
      }
    });

    if (allCorrect) {
      setState(() {
        score++;
      });
      _showWordCompleteModal();
    }
  }

  void _showWordCompleteModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Well Done!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Word: $translatedWord"),
              const SizedBox(height: 10),
              Text("Meaning: $definition"),
              const SizedBox(height: 10),
              Text("Example: $example"),
              const SizedBox(height: 10),
              Text("Score: $score/5"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextWord();
              },
              child: Text(currentWordIndex < 4 ? "Next Word" : "Finish"),
            ),
          ],
        );
      },
    );
  }

  void _nextWord() {
    setState(() {
      currentWordIndex++;
    });

    if (currentWordIndex < 5) {
      _loadCurrentWord();
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Completed!"),
          content: Text("Your final score: $score/5"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text("Hangman"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (translatedWord.isEmpty && !isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hangman")),
        body: const Center(
            child: Text('Failed to load words. Please try again.')),
      );
    }

    List<String> wordLetters = translatedWord.split("");

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: const Text("Hangman"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Word: ${currentWordIndex + 1}/5",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC6D5),
              Color(0xFFFFE3B9),
              Color(0xFFFFF0D9),
              Color(0xFFFFF9F0),
              Color(0xFFFEFEFE),
              Color(0xFFFBFBFD),
              Color(0xFFF6F3FD),
              Color(0xFFE1D6FF),
              Color(0xFFB8D5FF),
            ],
            stops: [0.0, 0.09, 0.22, 0.27, 0.28, 0.67, 0.78, 0.86, 0.91],
          ),
        ),
        child: Column(
          children: [
            // Hangman figure with fixed height
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding:
                  const EdgeInsets.only(left: 7, right: 7, top: 10, bottom: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  figure("assets/hangman/pole.png", tries >= 0),
                  figure("assets/hangman/head.png", tries >= 1),
                  figure("assets/hangman/body.png", tries >= 2),
                  figure("assets/hangman/leftArm.png", tries >= 3),
                  figure("assets/hangman/rightArm.png", tries >= 4),
                  figure("assets/hangman/leftLeg.png", tries >= 5),
                  figure("assets/hangman/rightLeg.png", tries >= 6),
                ],
              ),
            ),

            // Definition
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    "Meaning: $definition",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Example: $example",
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Word letters with some spacing
            Container(
              height: 110,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: wordLetters.asMap().entries.map((entry) {
                    int index = entry.key;
                    String letter = entry.value;
                    return revealedIndices.contains(index)
                        ? _revealedLetterBox(letter)
                        : hiddenLetter(
                            letter,
                            !selectedChar.contains(letter.toUpperCase()),
                          );
                  }).toList(),
                ),
              ),
            ),

            // Keyboard - takes remaining space
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 6,
                  childAspectRatio: 1.3,
                  children: alphabets.split("").map((a) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          selectedChar.contains(a.toUpperCase())
                              ? (translatedWord.contains(a.toUpperCase())
                                  ? Colors.green[100]
                                  : Colors.red[100])
                              : Colors.white,
                        ),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 164, 164),
                            width: 1.0,
                          ),
                        )),
                      ),
                      onPressed: selectedChar.contains(a.toUpperCase())
                          ? null
                          : () {
                              setState(() {
                                selectedChar.add(a.toUpperCase());
                                if (!translatedWord
                                    .split("")
                                    .contains(a.toUpperCase())) {
                                  tries++;
                                  if (tries > 6) {
                                    _showGameOverModal();
                                  }
                                } else {
                                  _checkWinCondition();
                                }
                              });
                            },
                      child: Text(
                        a,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _revealedLetterBox(String letter) {
    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color.fromARGB(255, 208, 255, 151),
        border: Border.all(
          color: Colors.green,
          width: 1.5,
        ),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.green,
        ),
      ),
    );
  }
}
