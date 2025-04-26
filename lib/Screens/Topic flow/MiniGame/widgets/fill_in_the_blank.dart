import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FillInTheBlank extends StatelessWidget {
  final Function(String) onAnswer;
  final String userAnswer;

  const FillInTheBlank({
    super.key,
    required this.onAnswer,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 188, 214, 238),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 48, 48, 48).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: onAnswer,
                decoration: InputDecoration(
                  hintText: 'Type your answer...',
                  hintStyle: GoogleFonts.aBeeZee(
                    fontSize: 17,
                    color: const Color.fromARGB(255, 156, 156, 156),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 104, 130, 175),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                  onPressed: () => onAnswer(userAnswer),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromRGBO(233, 240, 250, 1),
                    foregroundColor: const Color.fromARGB(255, 46, 46, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
