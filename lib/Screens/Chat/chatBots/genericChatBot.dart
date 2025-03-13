import 'package:flutter/material.dart';

// GenericChatBotPage for other situations
class GenericChatBotPage extends StatelessWidget {
  final String situationTitle;

  GenericChatBotPage({required this.situationTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(situationTitle),
      ),
      body: Center(
        child: Text(
          'ChatBot for $situationTitle\n(Under Development)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
