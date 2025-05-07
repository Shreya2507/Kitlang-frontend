import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JumbledSentence extends StatefulWidget {
  final String correctAnswer;
  final Function(bool) onAnswerChecked;

  const JumbledSentence({
    super.key,
    required this.correctAnswer,
    required this.onAnswerChecked,
  });

  @override
  State<JumbledSentence> createState() => _JumbledSentenceState();
}

class _JumbledSentenceState extends State<JumbledSentence> {
  late List<String> correctWords;
  late List<String> shuffledWords;
  List<String> userArrangement = [];

  @override
  void initState() {
    super.initState();
    correctWords = widget.correctAnswer.split(' ');
    shuffledWords = List.from(correctWords)..shuffle();
  }

  void _selectWord(String word) {
    setState(() {
      if (userArrangement.contains(word)) {
        userArrangement.remove(word);
        shuffledWords.add(word);
      } else {
        userArrangement.add(word);
        shuffledWords.remove(word);
      }
    });
  }

  void _checkJumbledAnswer() {
    final userAnswer = userArrangement.join(' ');
    final isCorrect = userAnswer == widget.correctAnswer;
    widget.onAnswerChecked(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: userArrangement.map((word) {
              return GestureDetector(
                onTap: () => _selectWord(word),
                child: Chip(
                  label: Text(word),
                  backgroundColor: const Color(0xFF6EA4D6),
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Available words:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: shuffledWords.map((word) {
            return GestureDetector(
              onTap: () => _selectWord(word),
              child: Chip(
                label: Text(word),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFF6EA4D6),
                  width: 1,
                ),
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: userArrangement.length == correctWords.length
              ? _checkJumbledAnswer
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6EA4D6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Check Answer',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}