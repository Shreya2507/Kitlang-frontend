import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/Achievements/AchievementScreen.dart';
import 'package:frontend/Screens/Chat/getStartedPage.dart';
import 'package:frontend/Screens/Dictionary/Dict.dart';
import 'package:frontend/Screens/HomePage/components/menu_bottom_sheet.dart';
import 'package:frontend/Screens/HomePage/components/my_timeline_tile.dart';
import 'package:frontend/Screens/HomePage/components/custom_bottom_navbar.dart';
import 'package:frontend/Screens/HomePage/utils/data.dart';
import 'package:frontend/Screens/Introductions/conversation.dart';
import 'package:frontend/Screens/MiniGames/Hangman/hangman_start_screen.dart';
import 'package:frontend/Screens/MiniGames/Wordle/wordle_start_screen.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/Screens/SnapLearn/snap.dart';
import 'package:frontend/Screens/Topic%20flow/finale_screen.dart';
import 'package:frontend/Screens/Topic%20flow/theory_screen.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:frontend/Screens/TranslateImage/translateImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _pageIndex = 1;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  void _onTap(int index) {
    if (index == 0) {
      showMenuBottomSheet(context, _audioPlayer);
    }
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => DictionaryHomePage()));
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AchievementScreen(),
        ),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image and content
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(
            top: 70,
            left: 40,
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
            top: 190,
            left: 20,
            right: 20,
            bottom: 15,
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
                                    "Chapter ${classData["number"]}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: classData["subColor"] as Color,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    classData["title"] as String,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: classData["subColor"] as Color,
                                    )),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  classData["image"] as String,
                                  width: 50,
                                  height: 50,
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
                                  onTap: () async {
                                    await _audioPlayer
                                        .play(AssetSource('sounds/tap.wav'));
                                    await Future.delayed(
                                        const Duration(milliseconds: 1000));

                                    if (topic["title"] == "Introduction" ||
                                        topicIndex == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConversationScreen(
                                                  chapter: classIndex + 1),
                                        ),
                                      );
                                    } else if (topic["title"] ==
                                        "Chapter Quiz") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FinaleScreen(
                                            chapterIndex:
                                                classData["number"] as int,
                                            topicIndex: topicIndex,
                                            background: classIndex + 1,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TheoryScreen(
                                            classIndex:
                                                classData["number"] as int,
                                            topicIndex: topicIndex,
                                            learningPackage: {},
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 50),
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
                                      subColor: classData["subColor"] as Color,
                                      chapterIndex: classData["number"] as int,
                                      topicIndex: topicIndex,
                                      isNextTopic: false,
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
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _pageIndex,
        onTap: _onTap,
        navKey: _navKey,
      ),
    );
  }
}
