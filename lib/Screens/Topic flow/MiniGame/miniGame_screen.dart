import 'package:flutter/material.dart';
import 'package:frontend/Screens/Introductions/completion_screen.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/fill_in_the_blank.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/jumbled_sentence.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/listening_mcq.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/listening_typing.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/match_pronunciation.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/multiple_choice.dart';
import 'package:frontend/Screens/Topic%20flow/MiniGame/widgets/pronunciation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_wave/audio_wave.dart';

class MiniGameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  final int topicIndex;
  final int chapterIndex;

  const MiniGameScreen({
    super.key,
    required this.questions,
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

  int questionNumber = 1;

  @override
  void dispose() {
    _speechToText.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
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
    if (!question.containsKey('correct_answer')) {
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
      barrierDismissible: false,
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
              Navigator.of(context, rootNavigator: true).pop();
              _nextQuestion();
            },
            child: Text('Continue', style: GoogleFonts.poppins(fontSize: 18)),
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
        selectedOption = null;
        questionNumber++;
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
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => CompletionScreen(
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
        Positioned.fill(
          child: Image.asset(
            "assets/theory/Mini_back.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color.fromARGB(141, 184, 217, 248),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(color: Colors.black),
              automaticallyImplyLeading: true,
            ),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 7),
                            child: Text(
                              'Question No. $questionNumber',
                              style: GoogleFonts.nunito(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 157, 191, 245),
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
                                  const SizedBox(height: 20),
                                  question['question_type'] ==
                                          "listening_typing"
                                      ? Text(
                                          "Listen to the audio and type what you hear",
                                          style: GoogleFonts.nunito(
                                            fontSize: 25,
                                            wordSpacing: 1.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : question['question_type'] ==
                                              "pronounciation"
                                          ? Text(
                                              "Repeat after the audio",
                                              style: GoogleFonts.nunito(
                                                fontSize: 25,
                                                wordSpacing: 1.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : question['question_type'] ==
                                                  "listening_mcq"
                                              ? Text(
                                                  "Listen to the audio and select the correct option",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 23,
                                                    wordSpacing: 1.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              : question['question_type'] ==
                                                      "jumbled_sentence"
                                                  ? Text(
                                                      "Arrange the words to form a sentence",
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 25,
                                                        wordSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  : Text(
                                                      question['question'] ??
                                                          question['title'] ??
                                                          '',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 25,
                                                        wordSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                  const SizedBox(height: 30),
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
                  )),
            )),
      ],
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    switch (question['question_type']) {
      case 'type_in_the_blanks':
        return FillInTheBlank(
          onAnswer: (answer) => checkAnswer(answer),
          userAnswer: userAnswer,
        );
      case 'multiple_choice':
        return MultipleChoice(
          options: question['options'] as List<dynamic>,
          selectedOption: selectedOption,
          onSelect: (option) {
            setState(() => selectedOption = option);
            Future.delayed(
                const Duration(seconds: 1), () => checkAnswer(option));
          },
        );
      case 'pronounciation':
        return Pronunciation(
          question: question['question'],
          textToRead: question['text_to_read'],
          isListening: isListening,
          userAnswer: userAnswer,
          onListeningStateChanged: (isListening) {
            setState(() => this.isListening = isListening);
          },
          onAnswerReceived: (answer) {
            setState(() => userAnswer = answer);
            checkAnswer(answer);
          },
          speak: _speak,
        );
      case 'listening_mcq':
        return ListeningMCQ(
          textToRead: question['text_to_read'],
          options: question['options'] as List<dynamic>,
          selectedOption: selectedOption,
          onSelect: (option) {
            setState(() => selectedOption = option);
            Future.delayed(
                const Duration(seconds: 1), () => checkAnswer(option));
          },
          speak: _speak,
        );
      case 'listening_typing':
        return ListeningTyping(
          textToRead: question['text_to_read'] ?? question['correct_answer'],
          userAnswer: userAnswer,
          onAnswer: (answer) => userAnswer = answer,
          speak: _speak,
        );
      case 'match_words':
        if (question['options'] != null &&
            question['options'] is List<dynamic>) {
          try {
            List<String> options =
                question['options'].whereType<String>().toList();
            if (options.isNotEmpty) {
              return MatchPronunciation(
                options: options,
                onAnswerChecked: (isCorrect) {
                  if (isCorrect) {
                    setState(() => score++);
                    _showFeedback(true);
                  } else {
                    _showFeedback(false, 'Try again!');
                  }
                },
              );
            }
          } catch (e) {
            print('Error processing match question: $e');
          }
        }
        return const SizedBox();
      case 'jumbled_sentence':
        return JumbledSentence(
          correctAnswer: question['correct_answer'],
          onAnswerChecked: (isCorrect) {
            if (isCorrect) {
              setState(() => score++);
              _showFeedback(true);
            } else {
              _showFeedback(false, question['correct_answer']);
            }
          },
        );
      default:
        return Container(
          child: Text(
            'Unsupported question type',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        );
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('de-DE');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }
}
