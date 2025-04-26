import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/Chat/getStartedPage.dart';
import 'package:frontend/Screens/Dictionary/Dict.dart';
import 'package:frontend/Screens/HomePage/components/my_timeline_tile.dart';
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
      _showMenuBottomSheet();
    }
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => DictionaryHomePage()));
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  void _showMenuBottomSheet() {
    bool isMiniGamesExpanded =
        false; // Moved inside the builder to maintain state
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          // Add StatefulBuilder to manage local state
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 550,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with decorative elements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                            shadows: [
                              Shadow(
                                color: Colors.pink[100]!,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              )
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [Colors.pink[200]!, Colors.blue[200]!],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu Items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuItem(
                          icon: Icons.emoji_events,
                          title: 'Achievements',
                          iconColor: Colors.pink[600]!,
                          bgColor: Colors.pink[50]!,
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (_) => DictionaryHomePage()));
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          icon: Icons.question_answer,
                          title: 'Doubt Helper',
                          iconColor: Colors.blue[600]!,
                          bgColor: Colors.blue[50]!,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => GetStartedPage()));
                          },
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.sports_esports,
                              title: 'Mini Games',
                              iconColor: Colors.pink[600]!,
                              bgColor: Colors.pink[50]!,
                              onTap: () {
                                setState(() {
                                  isMiniGamesExpanded = !isMiniGamesExpanded;
                                });
                              },
                              trailing: RotationTransition(
                                turns: isMiniGamesExpanded
                                    ? AlwaysStoppedAnimation(0.5)
                                    : AlwaysStoppedAnimation(0),
                                child: Icon(Icons.expand_more,
                                    color: Colors.grey[400]),
                              ),
                            ),
                            if (isMiniGamesExpanded) ...[
                              const SizedBox(height: 8),
                              _buildSubMenuItem(
                                icon: Icons.castle,
                                title: 'Pixel Adventure',
                                onTap: () {},
                              ),
                              const SizedBox(height: 4),
                              _buildSubMenuItem(
                                icon: Icons.man_2,
                                title: 'Hangman',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HangmanStart()));
                                },
                              ),
                              // const SizedBox(height: 4),
                              // _buildSubMenuItem(
                              //   icon: Icons.hdr_auto,
                              //   title: 'Wordle',
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (_) => WordleStart()));
                              //   },
                              // ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          icon: Icons.camera_enhance,
                          title: 'Kit Lens',
                          iconColor: Colors.blue[600]!,
                          bgColor: Colors.blue[50]!,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TranslateImage()));
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          icon: Icons.auto_stories,
                          title: 'Snap & Learn',
                          iconColor: Colors.pink[600]!,
                          bgColor: Colors.pink[50]!,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => SnapImage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.pink[50]!.withOpacity(0.7),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.pink[600], size: 24),
              ),
              const SizedBox(width: 24), // Indent to align with parent item
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
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
          // Positioned(
          //   right: 10,
          //   bottom: 120,
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

          // Bottom App Bar
          // Positioned(
          //   right: 0,
          //   left: 0,
          //   bottom: 0,
          //   child: BottomAppBar(
          //     padding: EdgeInsets.all(0),
          //     color: Color.fromARGB(121, 211, 222, 250),
          //     notchMargin: 0,
          //     child: Row(
          //       // mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         // IconButton(
          //         //   icon: const Icon(
          //         //     FontAwesomeIcons.house,
          //         //     color: Colors.black,
          //         //   ),
          //         //   onPressed: () {
          //         //     setState(() {});
          //         //   },
          //         // ),
          //         IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.bookOpen,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => DictionaryHomePage(),
          //               ),
          //             );
          //           },
          //         ),
          //         IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.solidCommentDots,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => GetStartedPage(),
          //               ),
          //             );
          //           },
          //         ),
          //         IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.trophy,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {
          //             setState(() {});
          //           },
          //         ),
          //         IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.solidUser,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => ProfilePage(),
          //               ),
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navKey,
        index: _pageIndex,
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 211, 222, 250),
        buttonBackgroundColor: Color.fromARGB(255, 182, 201, 255),
        height: 60,
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Icon(Icons.menu, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.home, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.book, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.person,
              size: 30, color: Color.fromARGB(255, 56, 107, 246)),
        ],
        onTap: _onTap,
      ),
    );
  }
}
