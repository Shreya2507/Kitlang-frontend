import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';
import 'package:frontend/Screens/Topic%20flow/FlashcardScreen.dart';
import 'package:frontend/Screens/Topic%20flow/miniGame_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theory_service.dart';

class TheoryScreen extends StatefulWidget {
  final int classIndex;
  final int topicIndex;
  final int background;

  const TheoryScreen({
    required this.classIndex,
    required this.topicIndex,
    required this.background,
    Key? key,
  }) : super(key: key);

  @override
  _TheoryScreenState createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  String? currentText;
  List<String>? examplesList;
  List<Map<String, dynamic>>? questionsList;
  List<Map<String, dynamic>>? learntWordsList;
  String? errorMessage;
  int currentStep = 0;
  String title = "Theory";
  String? theoryText;
  String? storyText;
  bool isLoading = true;
  bool hasError = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadTheoryData();
  }

  Future<void> loadTheoryData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final theoryData = await TheoryService.fetchTheory(
        widget.classIndex,
        widget.topicIndex,
      );

      if (mounted) {
        setState(() {
          theoryText = theoryData.theory ?? 'No theory content available';
          storyText = theoryData.story ?? 'No story content available';
          examplesList = theoryData.examples ?? ['No examples available'];
          questionsList = theoryData.questions ?? [];
          learntWordsList = theoryData.learntWords ?? [];
          errorMessage = theoryData.error;
          currentText = theoryText;
          isLoading = false;

          // If all content is empty, show error
          if ((theoryText?.isEmpty ?? true) &&
              (storyText?.isEmpty ?? true) &&
              (examplesList?.isEmpty ?? true) &&
              (learntWordsList?.isEmpty ?? true)) {
            hasError = true;
            errorMessage = 'No content available for this topic';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to load content. Please try again.';
        });
      }
    }
  }

  Widget _buildLoadingScreen() {
    // List of your GIF asset paths
    final List<String> loadingGifs = [
      'assets/loading/loading.gif',
      'assets/loading/loading2.gif',
      'assets/loading/loading3.gif',
    ];

    // Select a random GIF
    final random = Random();
    final randomGif = loadingGifs[random.nextInt(loadingGifs.length)];

    return Stack(
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

        // Centered content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                child: Image.asset(
                  randomGif,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Loading your adventure...',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            errorMessage ?? 'Content not available',
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: loadTheoryData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6EA4D6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F3FD),
        body: _buildLoadingScreen(),
      );
    }

    if (hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F3FD),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          automaticallyImplyLeading: true,
        ),
        body: _buildErrorScreen(),
      );
    }

    final classData = classes[widget.classIndex - 1];
    final topicData = (classData['topics'] as List)[widget.topicIndex];
    final classTitle = classData['title'] as String;
    final topicTitle = topicData['title'] as String;
    final imagePath = 'assets/introductions/bg1.jpg';

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        automaticallyImplyLeading: true,
      ),
      extendBodyBehindAppBar: true,
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

          // Title box
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  183,
                  154,
                  221,
                ).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(66, 130, 75, 249),
                    offset: Offset(0, 6),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title & subtitle on the left
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classTitle,
                          style: GoogleFonts.nunito(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          topicTitle,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Circular image with outline on the right
                  Container(
                    width: 75,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 107, 96, 139),
                        width: 4,
                      ),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main text content
          Padding(
            padding: const EdgeInsets.only(
              top: 280,
              left: 16,
              right: 16,
              bottom: 60,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color.fromARGB(255, 201, 185, 234),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(31, 252, 242, 212),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.nunito(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 2.0,
                            color: const Color.fromARGB(255, 56, 55, 55),
                          ),
                        ),
                        Text(
                          errorMessage ?? currentText ?? "No content available",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            wordSpacing: 2.0,
                            color: const Color.fromARGB(255, 56, 55, 55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.only(
              top: 750,
              left: 16,
              right: 16,
              bottom: 0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  backgroundColor: const Color.fromARGB(
                    255,
                    110,
                    164,
                    214,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    currentStep++;

                    if (currentStep == 1) {
                      currentText = storyText ?? "No story available.";
                      title = "Story";
                    } else if (currentStep == 2) {
                      currentText = examplesList?.join("\n\n") ??
                          "No examples available.";
                      title = "Examples";
                    } else {
                      if ((learntWordsList?.isNotEmpty ?? false) ||
                          (questionsList?.isNotEmpty ?? false)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlashcardScreen(
                              learntWords: learntWordsList ?? [],
                              background: widget.background,
                              topicIndex: widget.topicIndex,
                              chapterIndex: widget.classIndex,
                              questions: questionsList ?? [],
                            ),
                          ),
                        );
                        // MaterialPageRoute(
                        //   builder: (context) => MiniGameScreen(
                        //     questions: questionsList ?? [],
                        //     background: widget.background,
                        //     topicIndex: widget.topicIndex,
                        //     chapterIndex: widget.classIndex,
                        //   ),
                        // ),
                        // );
                      }
                    }

                    // Animate AFTER rebuild
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  });
                },
                child: Text(
                  "Continue",
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
