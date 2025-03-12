import 'package:flutter/material.dart';
import 'package:frontend/Screens/Introductions/completion_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MiniGameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int background;
  final int topicIndex;
  final int chapterIndex;

  const MiniGameScreen(
      {super.key,
      required this.questions,
      required this.background,
      required this.topicIndex,
      required this.chapterIndex});

  @override
  State<MiniGameScreen> createState() => _MiniGameScreenState();
}

class _MiniGameScreenState extends State<MiniGameScreen> {
  int currentIndex = 0;
  int score = 0;
  String userAnswer = '';
  bool isListening = false;
  final SpeechToText _speechToText = SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void dispose() {
    _speechToText.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings(); // Open app settings
    } else if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  void checkAnswer(String? answer) {
    if (answer == null || answer.trim().isEmpty) {
      _showFeedback(false, 'No answer provided');
      return;
    }

    final question = widget.questions[currentIndex];
    if (!question.containsKey('correct_answer') &&
        question['question_type'] != 'match the following(words)') {
      print('Error: Missing correct_answer in question data');
      _showFeedback(false, 'Missing correct answer in data');
      return;
    }

    // Normalize answers
    String userAnswer =
        answer.trim().toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    String correctAnswer = question['correct_answer']
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '');

    print('User Answer: "$userAnswer", Correct Answer: "$correctAnswer"');

    if (userAnswer == correctAnswer) {
      setState(() => score++);
      _showFeedback(true);
    } else {
      _showFeedback(false, question['correct_answer']);
    }
  }

  void _showFeedback(bool isCorrect, [String? correctAnswer]) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental closing
      builder: (_) => AlertDialog(
        backgroundColor:
            isCorrect ? Colors.green.shade100 : Colors.red.shade100,
        title: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? Colors.green : Colors.red,
          size: 60,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCorrect ? 'Correct!' : 'Wrong answer!',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            if (!isCorrect && correctAnswer != null) ...[
              const SizedBox(height: 8),
              Text(
                'Correct Answer: $correctAnswer',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // Close dialog only
              _nextQuestion(); // Load next question
            },
            child: Text('Next', style: GoogleFonts.poppins(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        userAnswer = '';
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.blue.shade100,
        title: Text('Game Over!',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
        content: Text(
          'You scored $score out of ${widget.questions.length}!',
          style: GoogleFonts.poppins(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // Close the dialog
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => CompletionScreen(
                    background: widget.background,
                    topicIndex: widget.topicIndex,
                    chapterIndex: widget.chapterIndex,
                  ),
                ),
              );
            },
            child: Text('OK', style: GoogleFonts.poppins(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

    return Stack(children: [
      // Background image
      Positioned.fill(
        child: Image.asset("assets/introductions/bg${widget.background}.jpg",
            fit: BoxFit.cover),
      ),

      Scaffold(
        backgroundColor: Colors.pink.withOpacity(0.3),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 103, 96, 195),
          title: Text('Score: $score',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        question['title'] ?? question['question'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (question.containsKey('question_native'))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            question['question_native'],
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildQuestionWidget(question),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    switch (question['question_type']) {
      case 'correct option from multiple options':
        return _buildMultipleChoice(question);
      case 'type in the blanks':
        return _buildFillInTheBlank();
      case 'speak(testing)':
        if (question['question'] is String) {
          return _buildSpeaking(question['question']);
        }
        return const SizedBox(); // Fallback if data is invalid
      case 'listen':
        return _buildListening(question);
      case 'match the following(words)':
        if (question['question'] is List<dynamic>) {
          return _buildMatchPronunciation(
            List<String>.from(question['question']),
          );
        }
        return const SizedBox(); // Fallback if data is invalid
      default:
        return Container();
    }
  }

  Widget _buildFillInTheBlank() {
    return Column(
      children: [
        TextField(
          onChanged: (value) => userAnswer = value,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            filled: true, // Enables background color
            fillColor: Colors.white, // Sets background color to white
            border: OutlineInputBorder(
              // Optional: adds a border
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => checkAnswer(userAnswer),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildMultipleChoice(Map<String, dynamic> question) {
    return Column(
      children: (question['options'] as List).map((option) {
        return ElevatedButton(
          onPressed: () => checkAnswer(option),
          child: Text(option),
        );
      }).toList(),
    );
  }

  Widget _buildSpeaking(String prompt) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await _requestPermissions();

            if (await _speechToText.hasPermission &&
                !_speechToText.isListening) {
              bool available = await _speechToText.initialize(
                onStatus: (status) => print('Status: $status'),
                onError: (error) => print('Error: $error'),
              );

              if (available) {
                setState(() => isListening = true);
                _speechToText.listen(
                  onResult: (result) {
                    setState(() {
                      userAnswer = result.recognizedWords;
                    });
                    // Only stop listening and check the answer if speech is complete
                    if (result.finalResult) {
                      _speechToText.stop();
                      setState(() => isListening = false);
                      checkAnswer(userAnswer);
                    }
                  },
                  localeId: 'de_DE', // Set to German locale
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Speech recognition not available')),
                );
              }
            } else {
              if (_speechToText.isListening) {
                await _speechToText.stop();
                setState(() => isListening = false);
                checkAnswer(userAnswer);
              }
            }
          },
          child: Text(isListening ? 'Stop' : 'Speak'),
        ),
        if (userAnswer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(94, 0, 0, 0),
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                'You said: $userAnswer',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('de-DE'); // Set to German
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Widget _buildListening(Map<String, dynamic> question) {
    return Column(
      children: (question['options'] as List).map((option) {
        return ElevatedButton(
          onPressed: () => checkAnswer(option),
          child: Text(option),
        );
      }).toList(),
    );
  }

  Widget _buildMatchPronunciation(List<String> options) {
    Map<String, String> audioMap = {
      'der Hund': 'assets/audio/der_hund.mp3',
      'die Katze': 'assets/audio/die_katze.mp3',
      'ein Hund': 'assets/audio/ein_hund.mp3',
      'eine Katze': 'assets/audio/eine_katze.mp3',
    };

    Map<String, String?> matchedAnswers = {};
    Map<String, bool> matchResults = {};

    return StatefulBuilder(
      builder: (context, setState) {
        void _checkMatch(String key, String value) {
          bool isCorrect = key == value;
          setState(() {
            matchedAnswers[key] = value;
            matchResults[key] = isCorrect;
            if (isCorrect) {
              score++; // Increase score for correct match
            }
          });
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Words to match
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: options.map((word) {
                    return Draggable<String>(
                      data: word,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple, width: 1),
                        ),
                        child: Text(
                          word,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade300,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Text(
                            word,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Text(
                            word,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Right side: Audio buttons (DragTargets)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: audioMap.keys.map((word) {
                    bool? isMatched = matchResults[word];

                    return DragTarget<String>(
                      onAccept: (receivedWord) {
                        _checkMatch(word, receivedWord);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return ElevatedButton.icon(
                          onPressed: () async {
                            await _speak(word);
                          },
                          icon: const Icon(Icons.volume_up),
                          label: Text(
                            matchedAnswers[word] ?? 'Play Audio',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isMatched == true
                                  ? Colors.green
                                  : isMatched == false
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMatched == true
                                ? Colors.green.shade100
                                : isMatched == false
                                    ? Colors.red.shade100
                                    : Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isMatched == true
                                    ? Colors.green
                                    : isMatched == false
                                        ? Colors.red
                                        : Colors.purple,
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Submit Button (Show only if all are matched)
            if (matchedAnswers.length == options.length)
              ElevatedButton(
                onPressed: () {
                  bool allCorrect =
                      matchResults.values.every((result) => result);
                  if (allCorrect) {
                    _showFeedback(true);
                  } else {
                    _showFeedback(false, 'Try again!');
                  }
                },
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
          ],
        );
      },
    );
  }
}
