import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/Screens/Introductions/convo_data.dart';
import 'package:frontend/Screens/Introductions/completion_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bubble/bubble.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import "../HomePage/utils/data.dart";
import 'package:audioplayers/audioplayers.dart';

class ConversationScreen extends StatefulWidget {
  final int chapter;

  ConversationScreen({required this.chapter});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  int conversationIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an AudioPlayer instance
  bool _isPlaying = false;

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

    _playBackgroundAudio();
  }

  Future<void> _playBackgroundAudio() async {
    try {
      // Replace 'your_audio.mp3' with the actual path to your audio file
      await _audioPlayer.play(AssetSource('sounds/intro.mp3'));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _stopBackgroundAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopBackgroundAudio(); // Stop audio when the screen is disposed
    _audioPlayer.dispose(); // Release the audio player resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final convoData = ConvoData.getConvoData(widget.chapter);
    final conversationList = convoData.conversations;
    String currentText = conversationList[conversationIndex]['text'] ?? '';
    String currentCharacter1 = conversationList[conversationIndex]
            ['character1'] ??
        convoData.character1;
    String currentCharacter2 = conversationList[conversationIndex]
            ['character2'] ??
        convoData.character2;

    int wordCount = currentText.split(' ').length; // Count words

    // print(wordCount);
    final isCharacter1Speaking =
        conversationList[conversationIndex]['speaker'] == 'character1';

    if (wordCount > 28 && !isExpanded) {
      // Change 15 to whatever word count you prefer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isExpanded = true;
        });
      });
    }

    void _showWordPromptDialog(String expectedWord) {
      TextEditingController controller = TextEditingController();

      void checkInput() {
        final userInput = controller.text.trim();

        if (userInput.toLowerCase() == expectedWord.toLowerCase()) {
          // Correct answer — close dialog and proceed
          Navigator.of(context, rootNavigator: true).pop();

          setState(() {
            isExpanded = false;
            conversationIndex++;
          });
        } else {
          // Incorrect answer — show error and keep the dialog open
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Oops! Try again.')));
        }
      }

      showDialog(
        context: context,
        barrierDismissible: false, // Force user to answer correctly
        builder: (context) => AlertDialog(
          title: Text('Enter the word'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Type the correct word'),
          ),
          actions: [
            TextButton(onPressed: checkInput, child: Text('Submit')),
          ],
          backgroundColor: Color.fromARGB(255, 248, 222, 176),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded corners
          ),
        ),
      );
    }

    void _navigateToMiniGame() async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CompletionScreen(chapterIndex: widget.chapter, topicIndex: 0),
        ),
      );

      // After returning, continue to the next dialogue
      setState(() {
        isExpanded = false;
        conversationIndex++;
      });
    }

    void handleNavigation() {
      // final topics = classes[widget.chapter]["topics"] as List? ?? [];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CompletionScreen(chapterIndex: widget.chapter, topicIndex: 0),
        ),
      );
      // setState(() {
      //   topics[0]["isPast"] = true;
      // });
    }

    //
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(convoData.background, fit: BoxFit.cover),
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

          // Animated "Story Time" Banner
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 123, 116, 220).withOpacity(0.7),
                  border: Border.all(
                    color: Color.fromARGB(255, 95, 56, 122), // Border color
                    width: 1, // Border thickness (adjust as needed)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(137, 254, 252, 252),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  convoData.scene,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(246, 197, 114, 1),
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.orange,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Character and Conversation UI
          Align(
            alignment: isCharacter1Speaking
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isCharacter1Speaking
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
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
                                    conversationList[conversationIndex]
                                            ['text'] ??
                                        '',
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
                      nip: isCharacter1Speaking
                          ? BubbleNip.leftBottom
                          : BubbleNip.rightBottom,
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
                              conversationList[conversationIndex]['text'] ?? '',
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
                    isCharacter1Speaking
                        ? currentCharacter1
                        : currentCharacter2,
                    width: 200,
                    gaplessPlayback: true,
                  ),
                ],
              ),
            ),
          ),

          // Previous Arrow Button
          if (conversationIndex > 0) // Only show if not the first conversation
            Positioned(
              bottom: 30,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (conversationIndex > 0) {
                      isExpanded = false;
                      conversationIndex--;
                    }
                  });
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
                  Icons.chevron_left, // Left arrow icon
                  color: Colors.yellow,
                  size: 35,
                ),
              ),
            ),

          // Next Arrow Button
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                final currentDialogue = conversationList[conversationIndex];

                if (currentDialogue.containsKey('action')) {
                  final action = currentDialogue['action'];

                  if (action == 'prompt') {
                    final expectedWord = currentDialogue['expectedWord'] ?? '';
                    _showWordPromptDialog(expectedWord);
                  } else if (action == 'navigate') {
                    handleNavigation();
                  }
                } else {
                  setState(() {
                    if (conversationIndex < conversationList.length - 1) {
                      conversationIndex++;
                    } else {
                      // Navigate to LevelCompleteScreen without popping back immediately
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompletionScreen(
                              chapterIndex: widget.chapter, topicIndex: 0),
                        ),
                      );
                    }
                  });
                }
              },

              // onPressed: () {
              //   setState(() {
              //     if (conversationIndex < conversationList.length - 1) {
              //       isExpanded = false;
              //       conversationIndex++;
              //     } else {
              //       Navigator.pop(context);
              //     }
              //   });
              // },
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
