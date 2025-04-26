import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class CompletionScreen extends StatefulWidget {
  final int chapterIndex;
  final int topicIndex;

  CompletionScreen({
    required this.chapterIndex,
    required this.topicIndex,
  });

  @override
  _CompletionScreenState createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an AudioPlayer instance
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 1), // Animation duration
      vsync: this, // TickerProvider
    );

    // Create a Tween for scaling the text
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // The curve for the animation
      ),
    );

    // Start the animation when the widget is built
    _controller.forward();

    _playBackgroundAudio();
  }

  Future<void> _playBackgroundAudio() async {
    try {
      // Replace 'your_audio.mp3' with the actual path to your audio file
      await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
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
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
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
            ),
          ),

          // Background overlay (for depth)
          Positioned.fill(
            child: Container(
              color: Color.fromARGB(255, 255, 44, 94).withOpacity(0.2),
            ),
          ),

          // Cat image animation (for cuteness)
          Positioned(
            top: 35, // Adjust this value to position the image
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/introductions/zhuaHug.gif'), // Your cat image path
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Main content container with shadow, rounded corners, and border
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background for the container
                borderRadius: BorderRadius.circular(35), // Rounded corners
                border: Border.all(
                  color: Colors.orangeAccent, // Border color
                  width: 3, // Border width
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Softer shadow
                    offset: Offset(0, 4), // Offset of the shadow
                    blurRadius: 15, // Larger blur radius
                  ),
                ],
              ),
              padding: EdgeInsets.all(25), // Padding inside the container
              margin:
                  EdgeInsets.symmetric(horizontal: 50), // Margin for spacing
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Completion icon with a gold color
                  Icon(Icons.emoji_events,
                      size: 120, color: Color.fromARGB(255, 250, 194, 110)),
                  SizedBox(height: 10),

                  // Animated "Congratulations!" Text with Scale Animation
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Text(
                          "Congratulations!",
                          style: GoogleFonts.poppins(
                            // Use Google Fonts
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 53, 53),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 15),
                  Text(
                    "You have completed this topic!",
                    style: GoogleFonts.poppins(
                      // Use Google Fonts
                      fontSize: 18,
                      color: Color.fromARGB(255, 57, 57, 57)
                          .withOpacity(0.7), // Adjusted color for readability
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Positioned container for the buttons at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Back Button
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Set fixed width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/', // Navigate to the root route (home screen)
                        (route) =>
                            false, // Remove all previous routes from the stack
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 136, 220, 250),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor:
                          Color.fromARGB(255, 77, 156, 229).withOpacity(0.4),
                      elevation: 10, // Adding elevation for a floating effect
                    ),
                    child: Text("Back to Home page",
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 74, 70, 177),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(height: 15), // Add spacing between the buttons

                // Continue Button
                // Container(
                //   width: MediaQuery.of(context).size.width *
                //       0.8, // Set fixed width
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // to the next topic
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => CompletionScreen(
                //             background: convoData.background,
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.greenAccent,
                //       padding:
                //           EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(25),
                //       ),
                //       shadowColor: Colors.greenAccent.withOpacity(0.4),
                //       elevation: 10, // Adding elevation for a floating effect
                //     ),
                //     child: Text(
                //       "Continue to Next Topic",
                //       style: GoogleFonts.poppins(
                //         fontSize: 20,
                //         fontWeight: FontWeight.w600,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
