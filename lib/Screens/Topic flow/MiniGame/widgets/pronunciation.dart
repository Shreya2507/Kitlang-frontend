import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Pronunciation extends StatefulWidget {
  final String question;
  final String textToRead;
  final bool isListening;
  final String userAnswer;
  final Function(bool) onListeningStateChanged;
  final Function(String) onAnswerReceived;
  final Function(String) speak;

  const Pronunciation({
    super.key,
    required this.question,
    required this.textToRead,
    required this.isListening,
    required this.userAnswer,
    required this.onListeningStateChanged,
    required this.onAnswerReceived,
    required this.speak,
  });

  @override
  State<Pronunciation> createState() => _PronunciationState();
}

class _PronunciationState extends State<Pronunciation> {
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    widget.onListeningStateChanged(true);

    await _speechToText.listen(
      onResult: (result) {
        final spokenText = result.recognizedWords;
        print("User said: $spokenText"); // 🔈 Print to console
        widget.onAnswerReceived(spokenText);
        widget.onListeningStateChanged(false);
        _speechToText.stop();
      },
    );
  }

  void _stopListening() {
    widget.onListeningStateChanged(false);
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text(
          widget.question,
          style: GoogleFonts.nunito(
            fontSize: 17,
            wordSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => widget.speak(widget.textToRead),
          icon: const Icon(Icons.volume_up),
          label: const Text('Play Audio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6EA4D6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 80),
        if (widget.isListening)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: AudioWave(
              height: 40,
              animation: true,
              beatRate: const Duration(milliseconds: 80),
              spacing: 2,
              bars: List.generate(
                20,
                (index) => AudioWaveBar(
                  heightFactor: index.isEven ? 0.5 : 0.8,
                  color: const Color.fromARGB(255, 174, 200, 239),
                  radius: 3,
                ),
              ),
            ),
          ),
        ElevatedButton.icon(
          onPressed: () {
            if (widget.isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6EA4D6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(widget.isListening ? Icons.stop : Icons.mic),
          label: Text(
            widget.isListening ? 'Stop' : 'Speak',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (widget.userAnswer.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(94, 0, 0, 0),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'You said: ${widget.userAnswer}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userAnswer.trim().toLowerCase() ==
                            widget.textToRead.trim().toLowerCase()
                        ? '✅ Great job! Pronunciation matched.'
                        : '❌ Try again. It didn’t match.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.userAnswer.trim().toLowerCase() ==
                              widget.textToRead.trim().toLowerCase()
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
