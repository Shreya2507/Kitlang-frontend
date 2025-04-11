import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';
import 'package:frontend/Screens/Topic%20flow/miniGame_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'theory_service.dart';

class TheoryScreen extends StatefulWidget {
  final int classIndex;
  final int topicIndex;
  final int background;

  TheoryScreen({
    required this.classIndex,
    required this.topicIndex,
    required this.background,
  });

  @override
  _TheoryScreenState createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  String? currentText;
  List<String>? examplesList;
  List<Map<String, dynamic>>? questionsList;
  String? errorMessage;
  int currentStep = 0;
  String? theoryText;
  String? storyText;

  List<String> storySteps = [];

  @override
  void initState() {
    super.initState();
    loadTheoryData();
  }

  Future<void> loadTheoryData() async {
    final theoryData = await TheoryService.fetchTheory(
      widget.classIndex,
      widget.topicIndex,
    );

    setState(() {
      theoryText = theoryData.theory ?? 'no data';
      storyText = theoryData.story ?? '';
      examplesList = theoryData.examples ?? [];
      questionsList = theoryData.questions ?? [];
      errorMessage = theoryData.error;
      currentText = theoryText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final classData = classes[widget.classIndex];
    final topicData = (classData['topics'] as List)[widget.topicIndex];

    final classTitle = classData['title'] as String;
    final topicTitle = topicData['title'] as String;
    final imagePath = 'assets/introductions/bg1.jpg';

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

          // Title box with shadow and image
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
                    child: Text(
                      errorMessage ?? currentText ?? "No content available",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        wordSpacing: 2.0,
                        color: const Color.fromARGB(255, 56, 55, 55),
                      ),
                    ),
                  ),

                  // Continue Button
                  SizedBox(
                    width: double
                        .infinity, // Makes the button take full width of its parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical:
                              16, // slightly taller for better touch target
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
                          } else if (currentStep == 2) {
                            currentText = examplesList?.join("\n\n") ??
                                "No examples available.";
                          } else {
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
                          }
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
