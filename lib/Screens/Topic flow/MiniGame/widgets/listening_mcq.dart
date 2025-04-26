import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListeningMCQ extends StatelessWidget {
  final String textToRead;
  final List<dynamic> options;
  final String? selectedOption;
  final Function(String) onSelect;
  final Function(String) speak;

  const ListeningMCQ({
    super.key,
    required this.textToRead,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
    required this.speak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => speak(textToRead),
          icon: const Icon(Icons.volume_up),
          label: const Text('Play Question Audio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6EA4D6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFECF4FB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: options.map<Widget>((option) {
              final bool isSelected = option == selectedOption;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => onSelect(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected 
                        ? const Color(0xFF6EA4D6) 
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    option,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}