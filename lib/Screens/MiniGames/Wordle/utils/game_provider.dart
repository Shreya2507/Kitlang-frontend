import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WordleGameProvider {
  int rowId = 0;
  int letterId = 0;

  static String gameMessage = "Can you guess the word ?";
  static String gameGuess = "";

  // static List<String> wordList = ["KATZE", "APFEL", "HALLO", "LIEBE", "LEUTE"];

  static bool gameOver = false;

  //game row
  static List<Letter> wordleRow = List.generate(5, (index) => Letter("", 0));

  //game board
  List<List<Letter>> wordleBoard =
      List.generate(5, (index) => List.generate(5, ((index) => Letter("", 0))));

  //functions for getting a random word
  Future<Map<String, dynamic>> fetchWord(String languageCode) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/random-word?lang=$languageCode'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch word');
    }
  }

  Future<Map<String, dynamic>> loadWord(String languageCode) async {
    try {
      return await fetchWord(languageCode);
    } catch (e) {
      print('Error: $e');
      return {}; // Return empty map in case of error
    }
  }

  //game base functions
  void initGame() async {
    gameGuess = "";
    Map<String, dynamic> wordData = await loadWord('de');

    String word = wordData["english_word"];
    String definition = wordData["definition"];
    String translatedWord = wordData["translated_word"];
  }

  //game insertion
  void insertWord(int index, Letter word) {
    wordleBoard[rowId][index] = word;
  }

  Future<bool> checkWordExist(String word) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/check-word?word=$word'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists']; // true or false from backend
    } else {
      throw Exception('Failed to check word existence');
    }
  }

  void resetGame() {
    wordleBoard =
        List.generate(5, (index) => List.generate(5, (index) => Letter("", 0)));
    rowId = 0;
    letterId = 0;
    gameMessage = "Can you guess all 5 words?";
    gameGuess = "";
    initGame(); // Ensure a new word is set
  }
}

class Letter {
  String? letter;
  int code = 0;
  Letter(this.letter, this.code);
}
