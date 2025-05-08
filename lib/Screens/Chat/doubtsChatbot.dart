import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Chat/jwt_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

class DoubtsChatbotPage extends StatefulWidget {
  final int situationNumber;
  final String situationTitle;

  const DoubtsChatbotPage({
    super.key,
    required this.situationNumber,
    required this.situationTitle,
  });

  @override
  _DoubtsChatbotPageState createState() => _DoubtsChatbotPageState();
}

class _DoubtsChatbotPageState extends State<DoubtsChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  late WebSocketChannel _channel;
  late String _token;
  bool _isLoading = false;
  bool _isFirstMessage = true;
  bool _isFirstMessageSent = false;

  String language = "german";
  String learnerLevel = "beginner";
  String nativeLanguage = "english";

  bool isAppVisible = true;
  late Timer _heartbeatTimer;

  @override
  void initState() {
    super.initState();
    _token = JwtService.createToken("user143", widget.situationNumber);
    _connectWebSocket();
    _startHeartbeat();
  }

  void _connectWebSocket() {
    final wsUrl =
        "wss://saran-2021-chat-service.hf.space/doubts_bot/$_token/$language/$learnerLevel/$nativeLanguage";
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    setState(() => _isLoading = true);

    _channel.stream.listen(
      (message) {
        String text;
        List<dynamic> sources = [];
        try {
          final parsed = jsonDecode(message);
          text = parsed['text'] ?? '';
          sources = List.from(parsed['sources'] ?? []);

          if (sources.isNotEmpty) {
            sources.sort(
              (a, b) => (b['score'] ?? 0).compareTo(a['score'] ?? 0),
            );
            final seen = <String>{};
            sources = sources
                .where((src) {
                  final id = '${src['chapter_name']}-${src['topic_name']}';
                  if (seen.contains(id)) return false;
                  seen.add(id);
                  return true;
                })
                .take(2)
                .toList();
          }
        } catch (_) {
          text = message.toString();
        }

        setState(() {
          _messages.add({'text': text, 'isUser': false, 'sources': sources});

          if (_isFirstMessage) {
            _isFirstMessage = false;
            _isFirstMessageSent = true;
          }
          _isLoading = false;
        });

        _scrollToBottom();
      },
      onError: (_) {
        setState(() {
          _messages.add({
            'text': 'Error: WebSocket connection failed.',
            'isUser': false,
            'sources': [],
          });
          _isLoading = false;
        });
      },
      onDone: () {
        setState(() {
          _messages.add({
            'text': 'WebSocket connection closed.',
            'isUser': false,
            'sources': [],
          });
        });
      },
    );
  }

  void sendMessage() {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'text': userMessage, 'isUser': true, 'sources': []});
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
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (isAppVisible) {
        _channel.sink.add('heartbeat');
      }
    });
  }

  @override
  void dispose() {
    _heartbeatTimer.cancel();
    _channel.sink.close(ws_status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: const Color(0xFFE8F1F9),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF2A2F66),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.situationTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1E4F1).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            164,
                            207,
                            223,
                          ).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                                      'images/paw_print_loading.gif',
                                      width: 60,
                                      height: 60,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Typing...'),
                                  ],
                                ),
                              );
                            }

                            final msg = _messages[index];
                            final isUser = msg['isUser'] as bool;
                            final text = msg['text'] as String;
                            final sources = msg['sources'] as List<dynamic>;

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? const Color(0xFF2A2F66)
                                            : const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(15),
                                          topRight: const Radius.circular(15),
                                          bottomLeft: isUser
                                              ? const Radius.circular(15)
                                              : const Radius.circular(0),
                                          bottomRight: isUser
                                              ? const Radius.circular(0)
                                              : const Radius.circular(15),
                                        ),
                                        border: Border.all(
                                          color: isUser
                                              ? const Color(0xFFF1F1F1)
                                              : const Color.fromARGB(
                                                  255,
                                                  192,
                                                  214,
                                                  230,
                                                ),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        text,
                                        style: GoogleFonts.lato(
                                          fontSize: 18,
                                          color: isUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (!isUser && sources.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            171,
                                            221,
                                            243,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.blueAccent.shade100,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              List.generate(sources.length, (
                                            i,
                                          ) {
                                            final src = sources[i];
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: double.infinity,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.85,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '📘 Source ${i + 1}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '• Chapter: ${src['chapter_name'] ?? 'N/A'}',
                                                  ),
                                                  Text(
                                                    '• Topic: ${src['topic_name'] ?? 'N/A'}',
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                  ],
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
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: _isFirstMessageSent,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF2A2F66)),
                    onPressed: _isFirstMessageSent ? sendMessage : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
