import 'package:flutter/material.dart';
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:frontend/Screens/Chat/getStartedPage.dart";
import "package:frontend/Screens/Dictionary/Dict.dart";
import "package:frontend/Screens/Introductions/conversation.dart";
import "package:frontend/Screens/ProfilePage.dart";
import "package:frontend/Screens/Topic%20flow/theory_screen.dart";
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
                  image: AssetImage('assets/home/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 70,
              left: 30,
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
              top: 200,
              left: 20,
              right: 20,
              bottom: 100,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: classes.length,
                  itemBuilder: (context, classIndex) {
                    final classData = classes[classIndex];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
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
                                      "Chapter ${classIndex + 1}",
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                              double _scale = 1.0;
                              bool _isPressed = false;

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return GestureDetector(
                                    onTapDown: (_) =>
                                        setState(() => _isPressed = true),
                                    onTapUp: (_) =>
                                        setState(() => _isPressed = false),
                                    onTapCancel: () =>
                                        setState(() => _isPressed = false),
                                    onTap: () {
                                      if (topic["title"] == "Introduction") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConversationScreen(
                                                    chapter: classIndex + 1),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TheoryScreen(
                                              classIndex: classIndex,
                                              topicIndex: topicIndex,
                                              background: classIndex + 1,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 50),
                                      decoration: BoxDecoration(
                                        color: _isPressed
                                            ? (classData["color"] as Color?)
                                                    ?.withOpacity(0.2) ??
                                                Colors.grey
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: MyTimeLineTile(
                                        isFirst: topic["isFirst"] as bool,
                                        isLast: topic["isLast"] as bool,
                                        isPast: topic["isPast"] as bool,
                                        image: topic["image"] as String,
                                        text: topic["title"] as String,
                                        color: classData["color"] as Color,
                                        subColor:
                                            classData["subColor"] as Color,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // CHATBOT BUTTON
            Positioned(
              right: 10,
              bottom: 120,
              child: Container(
                // padding: EdgeInsets.all(10),
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  onPressed: () => (),
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      FontAwesomeIcons.commentDots,
                      size: 27,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom App Bar
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: BottomAppBar(
                padding: EdgeInsets.all(0),
                color: Color.fromARGB(121, 211, 222, 250),
                notchMargin: 0,
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // IconButton(
                    //   icon: const Icon(
                    //     FontAwesomeIcons.house,
                    //     color: Colors.black,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {});
                    //   },
                    // ),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.bookOpen,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DictionaryHomePage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.solidCommentDots,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetStartedPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.trophy,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.solidUser,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
