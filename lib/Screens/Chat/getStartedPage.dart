import 'package:flutter/material.dart';
import 'package:frontend/Screens/Chat/allChat.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          FittedBox(
            fit: BoxFit.cover,
            child: Image.asset('assets/chatbot/back.png'),
          ),
          // Overlaying content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0, right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllChat()),
                  );
                },
                child: Text(
                  'Start Messaging',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Color(0xFFAD7CC2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
