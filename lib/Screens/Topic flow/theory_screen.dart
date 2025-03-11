// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:frontend/Screens/Introductions/convo_data.dart';
// import 'package:frontend/Screens/Introductions/level_complete_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bubble/bubble.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import "../HomePage/utils/data.dart";
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> chapter = classes[widget.classIndex];
    List<Map<String, dynamic>>? topics =
        chapter["topics"] as List<Map<String, dynamic>>?;
    String topic = (topics?[widget.topicIndex]["title"] as String?) ?? 'Error';

    String currentText =
        "This is the theory that will be displayed for ${topic}";
    int wordCount = currentText.split(' ').length; // Count words

    // Auto-expand the thought bubble
    if (wordCount > 28 && !isExpanded) {
      // Change 15 to whatever word count you prefer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isExpanded = true;
        });
      });
    }

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

          // // Animated "Story Time" Banner
          // Positioned(
          //   top: 90,
          //   left: 0,
          //   right: 0,
          //   child: FadeTransition(
          //     opacity: _fadeAnimation,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(vertical: 10),
          //       decoration: BoxDecoration(
          //         color: Color.fromARGB(255, 123, 116, 220).withOpacity(0.7),
          //         border: Border.all(
          //           color: Color.fromARGB(255, 95, 56, 122), // Border color
          //           width: 1, // Border thickness (adjust as needed)
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Color.fromARGB(137, 254, 252, 252),
          //             blurRadius: 8,
          //             spreadRadius: 2,
          //             offset: Offset(0, 1),
          //           ),
          //         ],
          //       ),
          //       child: Text(
          //         convoData.scene,
          //         textAlign: TextAlign.center,
          //         style: GoogleFonts.poppins(
          //           fontSize: 25,
          //           fontWeight: FontWeight.bold,
          //           color: Color.fromRGBO(246, 197, 114, 1),
          //           shadows: [
          //             Shadow(
          //               blurRadius: 10,
          //               color: Colors.orange,
          //               offset: Offset(2, 2),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

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
                  if (isExpanded)
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
                                    currentText,
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
                  else
                    // Normal Thought Bubble
                    Bubble(
                      margin: BubbleEdges.only(bottom: 10),
                      nip: BubbleNip.rightBottom,
                      color: Color.fromARGB(255, 248, 222, 176),
                      padding: BubbleEdges.all(20),
                      borderColor: Color.fromARGB(255, 189, 114, 27),
                      borderWidth: 2,
                      shadowColor: Color.fromARGB(246, 0, 0, 0),
                      elevation: 5,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 97, 59, 162),
                        ),
                        child: AnimatedTextKit(
                          key: ValueKey(conversationIndex),
                          animatedTexts: [
                            TypewriterAnimatedText(
                              currentText,
                              speed: Duration(milliseconds: 50),
                            ),
                          ],
                          totalRepeatCount: 1,
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ),
                  // Character Image
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
              onPressed: () {},
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
      ),
    );
  }
}
