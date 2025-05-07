import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';
import 'package:intl/intl.dart';

import 'package:google_fonts/google_fonts.dart';

class CompletionScreen extends StatefulWidget {
  final int chapterIndex;
  final int topicIndex;

  const CompletionScreen({
    super.key,
    required this.chapterIndex,
    required this.topicIndex,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String topicName = "";
  String chapterName = "Unknown Chapter";
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    fetchTopicNameAndSaveProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void fetchTopicNameAndSaveProgress() async {
    try {
      final chapter = classes[widget.chapterIndex] as Map<String, dynamic>;
      final topic =
          chapter["topics"][widget.topicIndex] as Map<String, dynamic>;
      setState(() {
        topicName = topic["title"];
        chapterName = chapter["title"] ?? "Unknown Chapter";
      });

      await _saveTopicCompletion();
    } catch (e) {
      print("Error fetching topic: $e");
      setState(() {
        _errorMessage = "Failed to load topic details";
      });
    }
  }

  Future<void> _saveTopicCompletion() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated");

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final completionKey =
          "chapter_${widget.chapterIndex}_topic_${widget.topicIndex}";

      await FirebaseFirestore.instance
          .collection("user_progress")
          .doc(userId)
          .set({
        "completed_topics": {
          completionKey: {
            "chapter_number": widget.chapterIndex,
            "topic_number": widget.topicIndex,
            "topic_name": topicName,
            "chapter_name": chapterName,
            "completed_at": FieldValue.serverTimestamp(),
            "date": today,
          }
        },
        "last_updated": FieldValue.serverTimestamp(),
        "completion_dates": {
          today: FieldValue.arrayUnion([completionKey])
        },
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print("Firestore error: ${e.message}");
      setState(() {
        _errorMessage =
            "Failed to save progress. Please check your connection.";
      });
    } catch (e) {
      print("Unexpected error: $e");
      setState(() {
        _errorMessage = "An unexpected error occurred";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
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

          // Color overlay
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 44, 94).withOpacity(0.2),
            ),
          ),

          // Hug GIF
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/introductions/zhuaHug.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Center Card
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.orangeAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events,
                      size: 120, color: Color.fromARGB(255, 250, 194, 110)),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Text(
                          "Congratulations!",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 54, 53, 53),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "You have completed:\n$topicName\nin $chapterName",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 57, 57, 57)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isSaving) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(
                      "Saving your progress...",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 57, 57, 57),
                      ),
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Bottom button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 220, 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: const Color.fromARGB(255, 77, 156, 229)
                          .withOpacity(0.4),
                      elevation: 10,
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 74, 70, 177),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
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
}
