import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:google_fonts/google_fonts.dart';

// Function to create JWT Token
String createJwtToken(String userId, int situationNumber) {
  const String secretKey = "your_secret_key";

  final expiry = DateTime.now().add(Duration(hours: 1));

  final payload = {
    "sub": userId,
    "exp": expiry.millisecondsSinceEpoch ~/ 1000,
    "situation": situationNumber
  };

  final jwt = JWT(payload);
  final token = jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS256);

  return token;
}

class FoodOrderingBot extends StatefulWidget {
  final int situationNumber;
  FoodOrderingBot({required this.situationNumber});
  @override
  _FoodOrderingBotState createState() => _FoodOrderingBotState();
}

class _FoodOrderingBotState extends State<FoodOrderingBot> {
  TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  bool _isLoading = false;
  late WebSocketChannel _channel;
  late String _token;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Situation Number: ${widget.situationNumber}");
    _token = createJwtToken(
        "user143", widget.situationNumber); // Generate token for user
    _connectWebSocket();
  }

  void _connectWebSocket() {
    String wsUrl = "wss://saran-2021-test-chatbot.hf.space/ws/$_token";
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
        _isLoading = false;
      });
      _scrollToBottom();
    }, onError: (error) {
      setState(() {
        _messages.add("Error: WebSocket connection failed.");
        _isLoading = false;
      });
    }, onDone: () {
      setState(() {
        _messages.add("WebSocket connection closed.");
      });
    });
  }

  void sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(userMessage);
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _channel.sink.close(ws_status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD7E0),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/chatbot/back.jpg"), // Set the background image
            fit: BoxFit.cover, // Ensure it covers the entire screen
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 25),
            Text(
              "Chatbot",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 175, 67, 67),
                fontFamily: 'Roboto',
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 215, 225, 240)
                          .withOpacity(0.9), // Slight transparency
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Color.fromARGB(255, 251, 106, 106), width: 3),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 30),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isLoading && index == _messages.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              children: [
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

                        bool isUserMessage = index.isEven;
                        return Align(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 21),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 15),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? Color.fromARGB(255, 243, 145, 144)
                                    : Color.fromARGB(255, 249, 218, 216),
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
                                border: Border.all(
                                    color: isUserMessage
                                        ? Colors.redAccent
                                        : const Color.fromARGB(
                                            255, 68, 138, 255),
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                _messages[index],
                                style: GoogleFonts.lato(
                                  // Replace 'lato' with your desired font
                                  fontSize: 18,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                Colors.white.withOpacity(0.8), // Background color with opacity
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Subtle shadow effect
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 4), // Position of the shadow
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.9), // Background color for the text field
                      borderRadius: BorderRadius.circular(
                          30.0), // Rounded corners for the input field
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 131, 131, 131)
                              .withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none, // No border line
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 131, 114,
                                208), // Custom color when focused
                            width: 2.0,
                          ),
                        ),
                      ),
                      onSubmitted: (value) => sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 131, 114, 208), // Accent color for button
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
