import 'package:flutter/material.dart';
import 'package:frontend/Screens/Introductions/completion_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_wave/audio_wave.dart';

class MiniGameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int background;
  final int topicIndex;
  final int chapterIndex;

  const MiniGameScreen({
    super.key,
    required this.questions,
    required this.background,
    required this.topicIndex,
    required this.chapterIndex,
  });

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
  String? selectedOption;

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
    String userAnswer = answer.trim().toLowerCase().replaceAll(
          RegExp(r'[^\w\s]'),
          '',
        );
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
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isCorrect && correctAnswer != null) ...[
              const SizedBox(height: 8),
              Text(
                'Correct Answer: $correctAnswer',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(); // Close dialog only
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
        title: Text(
          'Game Over!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You scored $score out of ${widget.questions.length}!',
          style: GoogleFonts.poppins(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(); // Close the dialog
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

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            "assets/theory/Mini_back.jpg",
            fit: BoxFit.cover,
          ),
        ),

        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(141, 184, 217, 248),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(color: Colors.black),
            automaticallyImplyLeading: true,
          ),
          // extendBodyBehindAppBar: true,
          body: Column(
            children: [
              const SizedBox(height: 30),

              // Question Number Label
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    'Question No. 1', // You can dynamically insert question number
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Main White Container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40, top: 5),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color.fromARGB(255, 157, 191, 245),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          question['title'] ?? question['question'],
                          style: GoogleFonts.nunito(
                            fontSize: 25,
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w700,
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
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 40),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height: 1,
                        ),
                        _buildQuestionWidget(question),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
        if (question['options'] != null &&
            question['options'] is List<dynamic>) {
          try {
            // Extract options from 'options' instead of 'question'
            List<String> options =
                question['options'].whereType<String>().toList();
            if (options.isNotEmpty) {
              return _buildMatchPronunciation(options);
            } else {
              print('Options list is empty');
            }
          } catch (e) {
            print('Error processing match question: $e');
          }
        } else {
          print('Invalid data for match the following(words)');
        }
        return const SizedBox(); // Fallback if data is invalid
      default:
        print('Unknown question type: ${question['question_type']}');
        return Container();
    }
  }

  Widget _buildFillInTheBlank() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          188,
          214,
          238,
        ), // Light grey background, you can change this
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 48, 48, 48).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) => userAnswer = value,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              hintStyle: GoogleFonts.aBeeZee(
                fontSize: 17,
                color: const Color.fromARGB(255, 156, 156, 156),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 245, 245, 245),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 104, 130, 175),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await Future.delayed(
                const Duration(seconds: 1),
              ); // ⏳ 1-second delay
              checkAnswer(userAnswer);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 16, // slightly taller for better touch target
              ),
              backgroundColor: const Color.fromRGBO(233, 240, 250, 1),
              foregroundColor: const Color.fromARGB(255, 46, 46, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoice(Map<String, dynamic> question) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFECF4FB), // Soft blue pastel
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (question['options'] as List).map<Widget>((option) {
          final bool isSelected = option == selectedOption;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedOption = option;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  checkAnswer(option);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? const Color(0xFF6EA4D6) // Selected soft blue
                    : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.transparent,
              ),
              child: Text(
                option,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpeaking(String prompt) {
    return Column(
      children: [
        if (isListening)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: AudioWave(
              height: 40, // controls overall wave height
              animation: true,
              beatRate: const Duration(milliseconds: 80),
              spacing: 2, // reduces gap between bars to make them tighter
              bars: List.generate(
                20, // more bars = thinner appearance
                (index) => AudioWaveBar(
                  heightFactor: index.isEven ? 0.5 : 0.8, // alternate height
                  color: const Color.fromARGB(255, 174, 200, 239), // soft blue
                  radius: 3, // small curve on top
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
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
                    if (result.finalResult) {
                      _speechToText.stop();
                      setState(() => isListening = false);
                      checkAnswer(userAnswer);
                    }
                  },
                  localeId: 'de_DE',
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Speech recognition not available'),
                  ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6EA4D6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(isListening ? Icons.stop : Icons.mic),
          label: Text(
            isListening ? 'Stop' : 'Speak',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (userAnswer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(94, 0, 0, 0),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                'You said: $userAnswer',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFECF4FB), // soft background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // makes buttons full width
        children: (question['options'] as List).map<Widget>((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () => checkAnswer(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                option,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMatchPronunciation(List<String> options) {
    if (options.isEmpty) {
      return const Center(
        child: Text(
          'No options available',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    Map<String, String> audioMap = {
      for (var word in options)
        word: 'assets/audio/${word.replaceAll(' ', '_').toLowerCase()}.mp3',
    };

    List<String> shuffledKeys = audioMap.keys.toList()..shuffle();

    Map<String, String?> matchedAnswers = {};
    Map<String, bool> matchResults = {};

    return StatefulBuilder(
      builder: (context, setState) {
        void _checkMatch(String key, String value) {
          bool isCorrect = key == value;
          setState(() {
            matchedAnswers[key] = value;
            matchResults[key] = isCorrect;
          });
        }

        Future<void> _playAudio(String word) async {
          String? audioPath = audioMap[word];
          if (audioPath != null) {
            try {
              final player = AudioPlayer();
              await player.play(AssetSource(audioPath));
            } catch (e) {
              print("Error playing audio for $word: $e");
            }
          }
        }

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🎯 Left: Words
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: options.map((word) {
                          return Draggable<String>(
                            data: word,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECF4FB),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF6EA4D6),
                                  width: 1,
                                ),
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
                                  color: const Color(0xFF6EA4D6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF41729F),
                                    width: 1,
                                  ),
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
                                  color: const Color(0xFFECF4FB),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF6EA4D6),
                                    width: 1,
                                  ),
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
                    ),

                    /// 🔊 Right: Drag Targets
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: shuffledKeys.map((word) {
                          bool? isMatched = matchResults[word];
                          return DragTarget<String>(
                            onAccept: (receivedWord) {
                              _checkMatch(word, receivedWord);
                            },
                            builder: (
                              context,
                              candidateData,
                              rejectedData,
                            ) {
                              return ElevatedButton.icon(
                                onPressed: () async {
                                  await _playAudio(word);
                                },
                                icon: const Icon(Icons.volume_up),
                                label: Text(
                                  matchedAnswers[word] ?? 'Play Audio',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isMatched == true
                                        ? Colors.green.shade700
                                        : isMatched == false
                                            ? Colors.red.shade700
                                            : Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isMatched == true
                                      ? const Color(0xFFD6F5D6)
                                      : isMatched == false
                                          ? const Color(0xFFFADADA)
                                          : Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: isMatched == true
                                          ? Colors.green
                                          : isMatched == false
                                              ? Colors.red
                                              : const Color(0xFF6EA4D6),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ✅ Submit Button
                if (matchedAnswers.length == audioMap.length)
                  ElevatedButton(
                    onPressed: () {
                      bool allCorrect = matchResults.values.every(
                        (result) => result,
                      );
                      if (allCorrect) {
                        setState(() {
                          score++;
                        });
                        _showFeedback(true);
                      } else {
                        _showFeedback(false, 'Try again!');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6EA4D6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
