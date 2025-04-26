import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MatchPronunciation extends StatefulWidget {
  final List<String> options;
  final Function(bool) onAnswerChecked;

  const MatchPronunciation({
    super.key,
    required this.options,
    required this.onAnswerChecked,
  });

  @override
  State<MatchPronunciation> createState() => _MatchPronunciationState();
}

class _MatchPronunciationState extends State<MatchPronunciation> {
  final FlutterTts _flutterTts = FlutterTts();
  List<int> audioIndices = [];
  List<String> shuffledWords = [];
  Map<String, String?> matchedAnswers = {};
  Map<String, bool> matchResults = {};

  @override
  void initState() {
    super.initState();
    // Create list of indices and shuffle them
    audioIndices = List.generate(widget.options.length, (index) => index)
      ..shuffle();
    shuffledWords = audioIndices.map((index) => widget.options[index]).toList();
  }

  void _checkMatch(String key, String value) {
    int wordIndex = widget.options.indexOf(key);
    int audioIndex = audioIndices[shuffledWords.indexOf(value)];

    bool isCorrect = wordIndex == audioIndex;
    setState(() {
      matchedAnswers[key] = value;
      matchResults[key] = isCorrect;
    });
  }

  Future<void> _playAudio(int index) async {
    try {
      await _flutterTts.setLanguage("de-DE");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(widget.options[audioIndices[index]]);
    } catch (e) {
      print("Error using TTS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left: Words (original order)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.options.map((word) {
                      return Draggable<String>(
                        data: word,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECF4FB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF6EA4D6),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            word,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6EA4D6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF41729F),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              word,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECF4FB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF6EA4D6),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              word,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                /// Right: Audio Buttons (shuffled)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: shuffledWords.asMap().entries.map((entry) {
                      int index = entry.key;
                      String word = entry.value;
                      bool? isMatched = matchResults[widget.options[audioIndices[index]]];

                      return DragTarget<String>(
                        onAccept: (receivedWord) => _checkMatch(receivedWord, word),
                        builder: (context, candidateData, rejectedData) {
                          return ElevatedButton.icon(
                            onPressed: () => _playAudio(index),
                            icon: const Icon(Icons.volume_up),
                            label: Text(
                              matchedAnswers.containsKey(widget.options[audioIndices[index]])
                                  ? matchedAnswers[widget.options[audioIndices[index]]]!
                                  : 'Play Audio',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isMatched == true
                                    ? Colors.green.shade700
                                    : isMatched == false
                                        ? Colors.red.shade700
                                        : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isMatched == true
                                  ? const Color(0xFFD6F5D6)
                                  : isMatched == false
                                      ? const Color(0xFFFADADA)
                                      : Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isMatched == true
                                      ? Colors.green
                                      : isMatched == false
                                          ? Colors.red
                                          : const Color(0xFF6EA4D6),
                                  width: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Submit Button
            if (matchedAnswers.length == widget.options.length)
              ElevatedButton(
                onPressed: () {
                  bool allCorrect = matchResults.values.every((result) => result);
                  widget.onAnswerChecked(allCorrect);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6EA4D6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}