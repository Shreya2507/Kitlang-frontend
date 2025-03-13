import 'package:flutter/material.dart';
import 'package:frontend/Screens/Chat/chatBots/foodOrderingChatBot.dart';
import 'package:frontend/Screens/Chat/chatBots/genericChatBot.dart';

import 'package:google_fonts/google_fonts.dart';

class AllChat extends StatefulWidget {
  @override
  _AllChatState createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  final List<Map<String, dynamic>> situations = [
    {
      'title': 'Ordering Food',
      'subtitle': 'Learn better by Conversing with a restaurant',
      'image': 'assets/chatbot/food_order1.png',
      'situation_id': 1
    },
    {
      'title': 'Booking a Hotel',
      'subtitle': 'Learn better by conversing with a hotel receptionist',
      'image': 'assets/chatbot/hotel.png',
      'situation_id': 2
    },
    {
      'title': 'Job Interview',
      'subtitle': 'Learn better by conversing with a potential employer',
      'image': 'assets/chatbot/interview.png',
      'situation_id': 3
    },
    {
      'title': 'Asking for Directions',
      'subtitle': 'Navigate a new city by asking directions',
      'image': 'assets/chatbot/interview.png',
      'situation_id': 4
    },
    {
      'title': 'Shopping at a Retail Store',
      'subtitle':
          'Practice buying clothes asking for sizes, prices and discounts',
      'image': 'assets/chatbot/interview.png',
      'situation_id': 5
    },
    {
      'title': 'Visiting a Doctor',
      'subtitle':
          'Learning How to describe symptoms and understanding medical advice',
      'image': 'assets/chatbot/interview.png',
      'situation_id': 6
    },
    {
      'title': 'Casual Chat ',
      'subtitle': 'Learn better by having a casual conversation',
      'image': 'assets/chatbot/food_order.png',
      'situation_id': 7
    },
  ];
  void navigateToChatBot(int situationId) {
    Widget destination;
    switch (situationId) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
        destination = FoodOrderingBot(situationNumber: situationId);
        break;
      default:
        destination = GenericChatBotPage(situationTitle: 'Generic Chat');
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chattie'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB9B0E1),
              Color(0xFFFFC6D5),
            ],
            stops: [0.07, 0.68],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // White container
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 252, 252),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Chatting Scenarios...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Situational Cards
                    Expanded(
                      child: ListView.builder(
                        itemCount: situations.length,
                        itemBuilder: (context, index) {
                          final situation = situations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Color.fromARGB(255, 255, 255, 255),
                              elevation: 5,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Left side: Title, Subtitle, and Start Now Button
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(height: 5),
                                          Text(
                                            situation['title'],
                                            style: GoogleFonts.lato(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  245, 111, 50, 152),
                                            ),
                                          ),
                                          Container(height: 10),
                                          Text(
                                            situation['subtitle'],
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 80, 80, 80),
                                            ),
                                          ),
                                          Container(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              navigateToChatBot(
                                                  situation['situation_id']);
                                              // if (situation['title'] ==
                                              //     'Ordering Food') {
                                              //   Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           FoodOrderingBot(situationNumber: 1,),
                                              //     ),
                                              //   );
                                              // }

                                              //  else {
                                              //   Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           GenericChatBotPage(
                                              //         situationTitle:
                                              //             situation['title'],
                                              //       ),
                                              //     ),
                                              //   );
                                              // }
                                            },
                                            child: Text(
                                              'Start Now!',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 192, 192, 192),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Right side: Image
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0), // Added padding
                                      child: Container(
                                        width: 123,
                                        height: 118,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image:
                                                AssetImage(situation['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Overlapping Cat image
            Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/chatbot/cat_image.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
