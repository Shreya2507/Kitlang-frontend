import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:frontend/Screens/Chat/getStartedPage.dart';
// import 'package:frontend/Screens/Dictionary/Dict.dart';
// import 'package:frontend/Flashcards/Flashcards.dart';
// import 'package:frontend/Screens/ProfilePage.dart';

import "utils/data.dart";
import "components/my_timeline_tile.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final List<String> cardTitles = [
  //   "Learn",
  //   "Speak",
  //   "Listen",
  //   "Real World Simulation"
  // ];
  // final List<String> cardTime = ["5hrs", "2hrs", "3hrs", "5hrs"];
  // final List<String> cardGames = [
  //   "flashcards",
  //   "flashcards",
  //   "flashcards",
  //   "chat"
  // ];

  // void _goToGame(String cardGame) {
  //   if (cardGame == "flashcards") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Flashcards(),
  //       ),
  //     );
  //   } else if (cardGame == "chat") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => GetStartedPage(),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background image and content
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home/bg.jpg'),
                  fit: BoxFit
                      .cover, // Ensure the image covers the entire container
                ),
              ),
            ),

            Positioned(
              top: 90,
              left: 20,
              child: Container(
                child: Text(
                  "Hello User !",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 27,
                    color: const Color.fromARGB(255, 57, 57, 57),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Positioned(
            //   top: 240,
            //   left: 0,
            //   right: 0,
            //   child: Text(
            //     "Learn something new today",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: const Color.fromARGB(255, 57, 57, 57),
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),

            //CLASSES
            Positioned(
              top: 240,
              left: 20,
              right: 20,
              bottom: 10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: classes.length,
                  itemBuilder: (context, classIndex) {
                    final classData = classes[classIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //CLASS
                        Container(
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: classData["color"] as Color,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Class ${classIndex + 1}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: classData["subColor"] as Color,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    classData["title"] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: classData["subColor"] as Color,
                                    )),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  classData["image"] as String,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //TOPICS
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (classData["topics"] as List).length,
                          itemBuilder: (context, topicIndex) {
                            final topic =
                                (classData["topics"] as List)[topicIndex];
                            return MyTimeLineTile(
                              isFirst: topic["isFirst"] as bool,
                              isLast: topic["isLast"] as bool,
                              isPast: topic["isPast"] as bool,
                              image: topic["image"] as String,
                              text: topic["title"] as String,
                              color: classData["color"] as Color,
                              subColor: classData["subColor"] as Color,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            //CHATBOT BUTTON
            // Positioned(
            //   right: 10,
            //   bottom: 100,
            //   child: Container(
            //     // padding: EdgeInsets.all(10),
            //     height: 65,
            //     width: 65,
            //     child: FloatingActionButton(
            //       onPressed: () => (),
            //       backgroundColor: Colors.white,
            //       shape: CircleBorder(),
            //       child: Padding(
            //         padding: EdgeInsets.all(8),
            //         child: Icon(
            //           FontAwesomeIcons.commentDots,
            //           size: 27,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // // Bottom App Bar
            // BottomAppBar(
            //   padding: EdgeInsets.all(0),
            //   color: Color.fromARGB(121, 211, 222, 250),
            //   notchMargin: 0,
            //   child: Row(
            //     // mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       IconButton(
            //         icon: const Icon(
            //           FontAwesomeIcons.house,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {
            //           setState(() {});
            //         },
            //       ),
            //       IconButton(
            //         icon: const Icon(
            //           FontAwesomeIcons.bookOpen,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => DictionaryHomePage(),
            //             ),
            //           );
            //         },
            //       ),
            //       IconButton(
            //         icon: const Icon(
            //           FontAwesomeIcons.trophy,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {
            //           setState(() {});
            //         },
            //       ),
            //       IconButton(
            //         icon: const Icon(
            //           FontAwesomeIcons.solidUser,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => ProfilePage(),
            //             ),
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
