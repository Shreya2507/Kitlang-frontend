import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodOrderingBot extends StatefulWidget {
  @override
  _FoodOrderingBotState createState() => _FoodOrderingBotState();
}

class _FoodOrderingBotState extends State<FoodOrderingBot> {
  TextEditingController _controller = TextEditingController();
  String _response = '';
  List<String> _messages = []; // To store conversation history
  bool _isLoading = false; // Flag to show loading state
  ScrollController _scrollController =
      ScrollController(); // Controller for scrolling

  // Send a message to the FastAPI bot and get a response
  Future<void> sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return; // Avoid sending empty messages

    setState(() {
      _messages.add(userMessage); // Add user message to the conversation
      _isLoading = true; // Start loading
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/food-ordering/'), // (url for emulator) //'https://saran-2021-fastapi-test-talk.hf.space/chat'
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': userMessage}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _response = json.decode(response.body)['response'];
        _messages.add(_response); // Add bot response to the conversation
        _isLoading = false; // Stop loading
      });
    } else {
      setState(() {
        _response = "Error: Unable to communicate with the bot.";
        _messages.add(_response); // Add error message to the conversation
        _isLoading = false; // Stop loading
      });
    }

    _controller.clear();

    // Scroll to the bottom after new message is added
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Ordering Bot")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 196, 188, 232),
              Color.fromARGB(255, 249, 216, 225),
            ],
            stops: [0.07, 0.68],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 25),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Row(
                            children: [
                              //  GIF for loading state
                              Image.asset(
                                'assets/chatbot/paw_print_loading.gif',
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(width: 10),
                              Text("Loading..."),
                            ],
                          ),
                        );
                      }

                      bool isUserMessage = index
                          .isEven; // User messages are even, bot responses are odd
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Color(0xFFF8A2A1) // User message color
                                  : Color(0xFFF1F0F6), // Bot response color
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: isUserMessage
                                    ? Radius.circular(15)
                                    : Radius.circular(0),
                                bottomRight: isUserMessage
                                    ? Radius.circular(0)
                                    : Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              _messages[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                    fontSize: 18, color: Colors.black.withOpacity(0.7)),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 109, 109, 109)
                          .withOpacity(0.5)),
                  filled: true,
                  fillColor:
                      Color.fromARGB(197, 255, 255, 255).withOpacity(0.5),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                onSubmitted: (value) {
                  sendMessage();
                  _controller.clear();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
