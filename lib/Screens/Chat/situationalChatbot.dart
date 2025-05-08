import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Chat/FeedbackDialog.dart';
import 'package:frontend/Screens/Chat/allChat.dart';
import 'package:frontend/Screens/Chat/jwt_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class Situationalbot extends StatefulWidget {
  final int situationNumber;
  final String situationTitle;
  const Situationalbot({
    super.key,
    required this.situationNumber,
    required this.situationTitle,
  });
  @override
  _SituationalbotState createState() => _SituationalbotState();
}

class _SituationalbotState extends State<Situationalbot> {
  final TextEditingController _controller = TextEditingController();
  final List<List<dynamic>> _messages = [];
  bool _isLoading = false;
  late WebSocketChannel _channel;
  late String _token;
  String language = "german";
  String learner_level = "beginner";
  String nativeLanguage = "english";
  final ScrollController _scrollController = ScrollController();
  bool isAppVisible = true; // Flag for app visibility
  late Timer _heartbeatTimer; // Timer for heartbeat
  bool _isFirstMessage = true; // Flag to track the first WebSocket message
  bool _isFirstMessageSent =
      false; // Track whether the first message has been sent

  @override
  void initState() {
    super.initState();
    print("Situation Number: ${widget.situationNumber}");
    _token = JwtService.createToken(
      "user143",
      widget.situationNumber,
    ); // Generate token for user
    _connectWebSocket();
    _startHeartbeat();
  }

  void _connectWebSocket() {
    String wsUrl =
        "wss://saran-2021-chat-service.hf.space/situation_bot/$_token/$language/$learner_level/$nativeLanguage";
    // "ws://192.168.1.9:8000/situation_bot/$_token/$language/$learner_level/$nativeLanguage";
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    // Set loading to true as soon as the connection starts
    setState(() {
      _isLoading = true; // Start loading when WebSocket connection starts
    });

    _channel.stream.listen(
      (message) {
        // Try parsing the message as JSON
        try {
          var parsedMessage = jsonDecode(message);
          // Check if the message is a feedback message and display a dialog
          print(parsedMessage);
          if (parsedMessage.containsKey('feedback') &&
              parsedMessage.containsKey('score') &&
              parsedMessage.containsKey('fluency')) {
            FeedbackDialog.show(
              context: context,
              feedback: parsedMessage['feedback'],
              fluency: parsedMessage['fluency'],
              relevance: parsedMessage['relevance'],
              score: parsedMessage['score'],
              // suggestions: parsedMessage['suggestions'],
              onOkayPressed: _closeWebSocket, // 👈 pass custom close
              vocabulary: parsedMessage['vocabulary'],
            );
          } else {
            setState(() {
              // If it's the first message, set the flag and handle it differently
              if (_isFirstMessage) {
                _messages.add([
                  "$parsedMessage",
                  false,
                ]); // Bot message
                _isFirstMessage = false;
                _isFirstMessageSent = true;
                _isLoading = false;
              } else {
                _messages.add(["$parsedMessage", false]);
                // Bot message
              }
              _isLoading = false;
            });
          }
        } catch (e) {
          // If parsing fails, treat it as a plain text message
          setState(() {
            // If it's the first message, set the flag and handle it differently
            if (_isFirstMessage) {
              _messages.add([
                "$message",
                false,
              ]); // Bot message
              _isFirstMessage = false;
              _isFirstMessageSent = true;
              _isLoading = false;
            } else {
              _messages.add(["$message", false]); // Bot message
            }
            _isLoading = false;
          });
        }
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _messages.add([
            "Error: WebSocket connection failed.",
            false,
          ]); // Bot message
          _isLoading = false;
        });
      },
      onDone: () {
        // setState(() {
        //   _messages.add(["WebSocket connection closed.", false]); // Bot message
        // });
      },
    );
  }

  void _closeWebSocket() {
    _channel.sink.close();
    // setState(() {
    //   _messages.add(["Connection ended by user.", false]); // Optional
    // });
    // Navigate to another screen without adding any message
  }

  void sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add([userMessage, true]); // User message
      _isLoading = true;
    });

    _channel.sink.add(userMessage);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (isAppVisible) {
        // Send heartbeat message only if app is visible
        _channel.sink.add("heartbeat");
      }
    });
  }

  @override
  void dispose() {
    _heartbeatTimer.cancel(); // Cancel heartbeat timer
    _channel.sink.close(ws_status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent layout shifting when keyboard appears
      backgroundColor: const Color(0xFFFFD7E0),
      body: Stack(
        children: [
          // Fixed background image
          Positioned.fill(
            child: Image.asset(
              "assets/chatbot/back.jpg", // Set the background image
              fit: BoxFit.cover, // Ensure it covers the entire screen
            ),
          ),
          // The rest of your UI (content)
          Column(
            children: [
              const SizedBox(height: 25),
              Stack(
                children: [
                  // Back Button at top-left
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AllChat()),
                        );
                      },
                    ),
                  ),
                  // Centered Title
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shadowed Title
                        Text(
                          widget.situationTitle,
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 170, 83, 83),
                            fontFamily: 'Roboto',
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.redAccent,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                        ),
                        // Normal Title
                        Text(
                          widget.situationTitle,
                          style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 249, 131, 131),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          229,
                          238,
                          254,
                        ).withOpacity(0.9), // Slight transparency
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            105,
                            153,
                            230,
                          ).withOpacity(0.9),
                          width: 1,
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        child: Column(
                          children: List.generate(
                            _messages.length + (_isLoading ? 1 : 0),
                            (index) {
                              if (_isLoading && index == _messages.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/chatbot/paw_print_loading.gif',
                                        width: 60,
                                        height: 60,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Typing..."),
                                    ],
                                  ),
                                );
                              }
                              String message = _messages[index][0];
                              bool isUserMessage = _messages[index][1];
                              return Align(
                                alignment: isUserMessage
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 21,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUserMessage
                                          ? const Color.fromARGB(
                                              255,
                                              250,
                                              106,
                                              103,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              168,
                                              190,
                                              234,
                                            ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(15),
                                        topRight: const Radius.circular(15),
                                        bottomLeft: isUserMessage
                                            ? const Radius.circular(15)
                                            : const Radius.circular(0),
                                        bottomRight: isUserMessage
                                            ? const Radius.circular(0)
                                            : const Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        color: isUserMessage
                                            ? const Color.fromARGB(
                                                255,
                                                247,
                                                123,
                                                123,
                                              )
                                            : const Color.fromARGB(
                                                255,
                                                192,
                                                203,
                                                238,
                                              ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                            255,
                                            27,
                                            67,
                                            97,
                                          ).withOpacity(
                                            0.2,
                                          ), // Shadow color (black with some transparency)
                                          spreadRadius:
                                              1, // Spread the shadow a bit
                                          blurRadius:
                                              8, // Softens the shadow for a smooth effect
                                          offset: Offset(
                                            2,
                                            4,
                                          ), // Horizontal and vertical displacement of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      message,
                                      style: GoogleFonts.nunito(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: isUserMessage
                                            ? Colors
                                                .white // Set user message color to white
                                            : Colors
                                                .black, // Keep bot message color as black
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ), // Adjust padding when keyboard is shown
                child: GestureDetector(
                  onTap: _isFirstMessageSent ? sendMessage : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: _isFirstMessageSent,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(
                                255,
                                131,
                                131,
                                131,
                              ).withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 131, 114, 208),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: const Color.fromARGB(255, 136, 34, 16),
                        ),
                        onPressed: _isFirstMessageSent ? sendMessage : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
