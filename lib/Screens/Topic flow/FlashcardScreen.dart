import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:frontend/Screens/Topic%20flow/miniGame_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> learntWords;
  final int background;
  final int topicIndex;
  final int chapterIndex;
  final List<Map<String, dynamic>> questions;

  const FlashcardScreen({
    super.key,
    required this.learntWords,
    required this.background,
    required this.topicIndex,
    required this.chapterIndex,
    required this.questions,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showMeaning = false;
  final FlutterTts _flutterTts = FlutterTts();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('de-DE');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _nextCard() {
    setState(() {
      _showMeaning = false;
      _currentIndex = (_currentIndex + 1) % widget.learntWords.length;
      _isFront = true;
      if (_controller.status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  void _previousCard() {
    setState(() {
      _showMeaning = false;
      _currentIndex = (_currentIndex - 1) % widget.learntWords.length;
      _isFront = true;
      if (_controller.status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  void _navigateToMiniGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiniGameScreen(
          questions: widget.questions,
          background: widget.background,
          topicIndex: widget.topicIndex,
          chapterIndex: widget.chapterIndex,
        ),
      ),
    );
  }

  void _flipCard() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFront = !_isFront;
      _showMeaning = !_showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.learntWords.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No flashcards available'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToMiniGame,
                child: Text('Go to Mini Game'),
              ),
            ],
          ),
        ),
      );
    }

    final currentWord = widget.learntWords[_currentIndex];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 247, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _navigateToMiniGame,
            child: Text(
              'Skip',
              style: GoogleFonts.nunito(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.learntWords.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 50),

          Text(
            "Let's revise some words !",
            style:
                GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // Flashcard with flip animation
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final angle =
                        _animation.value * 3.14159; // Convert to radians
                    final transform = Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateY(angle);

                    // Determine which side to show based on animation progress
                    if (_animation.value <= 0.5) {
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: _buildFrontCard(currentWord),
                      );
                    } else {
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(3.14159 + angle), // Flip the back card
                        alignment: Alignment.center,
                        child: _buildBackCard(currentWord),
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousCard,
                  icon: Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    padding: EdgeInsets.all(16),
                  ),
                ),

                // Speaker button
                IconButton(
                  onPressed: () => _speak(currentWord['word']),
                  icon: Icon(Icons.volume_up),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    padding: EdgeInsets.all(16),
                  ),
                ),

                // Next button
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == widget.learntWords.length - 1) {
                      _navigateToMiniGame();
                    } else {
                      _nextCard();
                    }
                  },
                  child: Text(
                    _currentIndex == widget.learntWords.length - 1
                        ? 'Finish'
                        : 'Next',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(Map<String, dynamic> currentWord) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Word',
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            currentWord['word'],
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flip_to_front, size: 30, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(
                      'Tap to flip',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackCard(Map<String, dynamic> currentWord) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Meaning',
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 0),
          Text(
            currentWord['meaning'],
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Example:',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currentWord['example'],
            style: GoogleFonts.nunito(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flip_to_front, size: 20, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(
                      'Tap to flip back',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
