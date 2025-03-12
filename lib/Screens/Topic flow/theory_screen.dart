// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:frontend/Screens/Introductions/convo_data.dart';
// import 'package:frontend/Screens/Introductions/level_complete_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bubble/bubble.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import "../HomePage/utils/data.dart";
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';
import 'package:frontend/Screens/Topic%20flow/miniGame_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class TheoryScreen extends StatefulWidget {
  final int classIndex;
  final int topicIndex;
  final int background;

  TheoryScreen(
      {required this.classIndex,
      required this.topicIndex,
      required this.background});

  @override
  _TheoryScreenState createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  int conversationIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String? currentText;
  List<String>? examplesList;
  List<Map<String, dynamic>>? questionsList;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fetchStory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchStory() async {
    try {
      final url = Uri.parse(
          'https://saran-2021-backend-kitlang.hf.space/generate_theory/${widget.classIndex}/${widget.topicIndex}/German/beginner'); // Replace with your API URL
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        // final data = json.decode(response.body);

        setState(() {
          currentText = data['story'];
          if (data['questions'] != null) {
            questionsList = List<Map<String, dynamic>>.from(data['questions']);
            print('Questions list updated: $questionsList');
          } else {
            print('No questions in response');
          }
          if (data['examples'] != null) {
            examplesList = List<String>.from(data['examples']);
            print('Examples list updated: $examplesList');
          } else {
            print('No questions in response');
          }

          isLoading = false;
          // print('Response status: ${response.statusCode}');
          // print('Response body: ${response.body}');
          print('Raw API response: ${response.body}');

          print('Questions list updated: $questionsList');

          // Auto-expand the thought bubble if the story is long enough
          if (currentText != null &&
              currentText!.split(' ').length > 28 &&
              !isExpanded) {
            isExpanded = true;
          }
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load story. Try again later.';
          print('Error: ${response.reasonPhrase}');
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> chapter = classes[widget.classIndex];
    List<Map<String, dynamic>>? topics =
        chapter["topics"] as List<Map<String, dynamic>>?;
    String topic = (topics?[widget.topicIndex]["title"] as String?) ?? 'Error';

    // String currentText =
    //     "This is the theory that will be displayed for ${topic}";

    //api call --> send, topic no.(widget.topicIndex) + chapter no.(widget.chapterIndex) + language(from global state) + learner_level(from gloabal state)

    //Q types that will be received
    //fill in the blanks
    //MCQ
    //Speaking-- sentence given + add speech to text, user pronounces and check
    //listen -- short passage/sentence given with 4 options
    //words given with pronounciations --match words to pronounciation

    isExpanded = true;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
                "assets/introductions/bg${widget.background}.jpg",
                fit: BoxFit.cover),
          ),

          // Background Overlay
          Positioned.fill(
            child: Container(color: Colors.pink.withOpacity(0.3)),
          ),

          //
          // Semi-transparent black background when expanded
          if (isExpanded)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),

          //
          // Vignette on the Sides Overlay
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 244, 214, 122).withOpacity(0.5),
                      Color.fromARGB(255, 252, 226, 187).withOpacity(0.0),
                      Colors.white.withOpacity(0.5),
                    ],
                    stops: [0.0, 0.5, 4.5],
                  ),
                ),
              ),
            ),
          ),

          // Show loading state
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
                strokeWidth: 4,
              ),
            )
          else ...[
            //home button
            Positioned(
              top: 35,
              left: 15,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 103, 96, 195).withOpacity(0.7),
                  ), // Purple button color
                  foregroundColor: MaterialStateProperty.all(
                    Colors.yellow,
                  ), // Yellow icon color
                  padding: MaterialStateProperty.all(EdgeInsets.all(18)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(10), // Add shadow
                ),
                child: Icon(
                  Icons.home, // Left arrow icon
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
            ),

            // Character and Conversation UI
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expanded Thought Bubble
                    // if (isExpanded)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.50,
                      padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 222, 176),
                        border: Border.all(
                          color: Color.fromARGB(255, 189, 114, 27),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(137, 0, 0, 0),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 90, 50, 158),
                              ),
                              child: AnimatedTextKit(
                                key: ValueKey(conversationIndex),
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    currentText ??
                                        "Oops ! Looks like something went wrong.\nPlease try again later.",
                                    speed: Duration(milliseconds: 50),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                isRepeatingAnimation: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    // else
                    //   // Normal Thought Bubble
                    //   Bubble(
                    //     margin: BubbleEdges.only(bottom: 10),
                    //     nip: BubbleNip.rightBottom,
                    //     color: Color.fromARGB(255, 248, 222, 176),
                    //     padding: BubbleEdges.all(20),
                    //     borderColor: Color.fromARGB(255, 189, 114, 27),
                    //     borderWidth: 2,
                    //     shadowColor: Color.fromARGB(246, 0, 0, 0),
                    //     elevation: 5,
                    //     child: DefaultTextStyle(
                    //       style: TextStyle(
                    //         fontSize: 22,
                    //         fontWeight: FontWeight.w500,
                    //         color: Color.fromARGB(255, 97, 59, 162),
                    //       ),
                    //       child: AnimatedTextKit(
                    //         key: ValueKey(conversationIndex),
                    //         animatedTexts: [
                    //           TypewriterAnimatedText(
                    //             currentText!,
                    //             speed: Duration(milliseconds: 50),
                    //           ),
                    //         ],
                    //         totalRepeatCount: 1,
                    //         isRepeatingAnimation: false,
                    //       ),
                    //     ),
                    //   ),
                    // Character Image
                    ,
                    Image.asset(
                      "assets/introductions/bora.png",
                      width: 200,
                      gaplessPlayback: true,
                    ),
                  ],
                ),
              ),
            ),

            // // Previous Arrow Button
            // if (conversationIndex > 0) // Only show if not the first conversation
            //   Positioned(
            //     bottom: 30,
            //     left: 20,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if (conversationIndex > 0) {
            //             isExpanded = false;
            //             conversationIndex--;
            //           }
            //         });
            //       },
            //       style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(
            //           Color.fromARGB(255, 103, 96, 195).withOpacity(0.7),
            //         ), // Purple button color
            //         foregroundColor: MaterialStateProperty.all(
            //           Colors.yellow,
            //         ), // Yellow icon color
            //         padding: MaterialStateProperty.all(EdgeInsets.all(18)),
            //         shape: MaterialStateProperty.all(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30),
            //           ),
            //         ),
            //         elevation: MaterialStateProperty.all(10), // Add shadow
            //       ),
            //       child: Icon(
            //         Icons.chevron_left, // Left arrow icon
            //         color: Colors.yellow,
            //         size: 35,
            //       ),
            //     ),
            //   ),

            // Next Arrow Button
            Positioned(
              bottom: 30,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  // final questionsList = [
                  //   {
                  //     "question":
                  //         "Was ist der Unterschied zwischen 'der' und 'ein'?",
                  //     "question_native":
                  //         "What is the difference between 'der' and 'ein'?",
                  //     "options": [
                  //       "'der' ist unbestimmt, 'ein' ist bestimmt",
                  //       "'der' ist bestimmt, 'ein' ist unbestimmt"
                  //     ],
                  //     "correct_answer":
                  //         "'der' ist bestimmt, 'ein' ist unbestimmt",
                  //     "question_type": "correct option from multiple options"
                  //   },
                  //   {
                  //     "question": "Fülle die Lücke: Ich habe ___ Hund gesehen.",
                  //     "question_native": "I saw ___ dog.",
                  //     "correct_answer": "einen",
                  //     "question_type": "type in the blanks"
                  //   },
                  //   {
                  //     "question": "Sprich: Ich liebe die deutsche Sprache!",
                  //     "correct_answer": "Ich liebe die deutsche Sprache!",
                  //     "question_type": "speak(testing)"
                  //   },
                  //   {
                  //     "question": "Hör zu: 'Das ist ein schönes Haus.'",
                  //     "options": [
                  //       "It is a beautiful house.",
                  //       "It is a big house."
                  //     ],
                  //     "correct_answer": "It is a beautiful house.",
                  //     "question_type": "listen"
                  //   },
                  //   {
                  //     "title": "Match the following words",
                  //     "question": [
                  //       "der Hund",
                  //       "die Katze",
                  //       "ein Hund",
                  //       "eine Katze"
                  //     ],
                  //     "question_type": "match the following(words)"
                  //   }
                  // ];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MiniGameScreen(
                        questions: questionsList ?? [],
                        background: widget.background,
                        topicIndex: widget.topicIndex,
                        chapterIndex: widget.classIndex,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 103, 96, 195).withOpacity(0.7),
                  ), // Purple button color
                  foregroundColor: MaterialStateProperty.all(
                    Colors.yellow,
                  ), // Yellow icon color
                  padding: MaterialStateProperty.all(EdgeInsets.all(18)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(10), // Add shadow
                ),
                child: Icon(
                  Icons.chevron_right, // Right arrow icon
                  color: Colors.yellow,
                  size: 35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
