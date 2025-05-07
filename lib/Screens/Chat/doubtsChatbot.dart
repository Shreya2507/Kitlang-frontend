import 'package:flutter/material.dart';

// doubtsChatbotPage for other situations
class doubtsChatbotPage extends StatelessWidget {
  final String situationTitle;

  const doubtsChatbotPage({super.key, required this.situationTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(situationTitle)),
      body: Center(
        child: Text(
          'ChatBot for $situationTitle\n(Under Development)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
