import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:audioplayers/audioplayers.dart';
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
import 'package:frontend/Screens/TranslateImage/translateImage.dart';
import 'package:frontend/Screens/UserProfile/settings/translation.dart';
import 'package:frontend/Screens/service/audio_controller.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final user = FirebaseAuth.instance.currentUser;
  DateTime? _lastPressedTime;
  final TranslationService _translator = TranslationService();
  bool _isLanguageLoaded = false;
  final int _pageIndex = 1;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  Future<void> _loadLanguage() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final selectedLang = store.state.selectedLanguageCode ?? 'en';
    await _translator.setLanguage(selectedLang);
    setState(() {
      _isLanguageLoaded = true;
    });
  }
final audioController = AudioController();
  @override
  void initState() {
    super.initState();
    _loadLanguage();
   AudioController().playTrack("assets/sounds/Music.mp3");

  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  

  Future<bool> _onWillPop() async {
    if (_lastPressedTime == null ||
        DateTime.now().difference(_lastPressedTime!) > const Duration(seconds: 2)) {
      _lastPressedTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translator.translate('press_back_again_to_exit'))),
      );
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

 bool _isTopicCompleted(Map<String, dynamic> completedTopics, int chapterIndex, int topicIndex) {
  final key = "chapter_${chapterIndex}_topic_$topicIndex";
  return completedTopics.containsKey(key);
}

bool _isNextTopic(Map<String, dynamic> completedTopics, int chapterIndex, int topicIndex) {
  if (topicIndex == 0) return false;
  final prevKey = "chapter_${chapterIndex}_topic_${topicIndex - 1}";
  final currKey = "chapter_${chapterIndex}_topic_$topicIndex";
  return completedTopics.containsKey(prevKey) && !completedTopics.containsKey(currKey);
}


  Future<void> _playTapSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/tap.wav'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _onTap(int index) async {
    await _playTapSound();
    
    switch (index) {
      case 0: // Menu
        showMenuBottomSheet(context, _audioPlayer);
        break;
      case 1: // Home
        if (ModalRoute.of(context)?.settings.name != '/') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
        break;
      case 2: // Dictionary
        if (ModalRoute.of(context)?.settings.name != '/dictionary') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DictionaryHomePage()),
          );
        }
        break;
      case 3: // Achievements
        if (ModalRoute.of(context)?.settings.name != '/achievements') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AchievementScreen()),
          );
        }
        break;
      case 4: // Profile
        if (ModalRoute.of(context)?.settings.name != '/profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLanguageLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: StoreConnector<AppState, Map<String, dynamic>>(
        converter: (store) => store.state.completedTopics ?? {},
        
        builder: (context, completedTopics) {
          print("completedTopics1: $completedTopics");

          return Scaffold(
            body: Stack(
              children: [
                // Background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/home/bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // User greeting
                Positioned(
                  top: 70,
                  left: 30,
                  child: Text(
                    user?.displayName ?? _translator.translate('guest'),
                    style: const TextStyle(
                      fontSize: 27,
                      color: Color(0xFF393939),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Classes and topics list
                Positioned(
                  top: 190,
                  left: 20,
                  right: 20,
                  bottom: 15,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: classes.length,
                    itemBuilder: (context, classIndex) {
                      final classData = classes[classIndex];
                      final translatedTitle = _translator.translate(classData["title"] as String);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Class container
                            Container(
                              height: 100,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: classData["color"] as Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_translator.translate("chapter")} ${classIndex + 1}",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: classData["subColor"] as Color,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        translatedTitle,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: classData["subColor"] as Color,
                                      ),
                                    ),
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

                            // Topics list
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: (classData["topics"] as List).length,
                              itemBuilder: (context, topicIndex) {
                                final topic = (classData["topics"] as List)[topicIndex];
                                final isCompleted = _isTopicCompleted(completedTopics, classIndex+1, topicIndex);
                                final isNextTopic = _isNextTopic(completedTopics, classIndex + 1, topicIndex);
                                final isFirstTopic = classIndex == 1 && topicIndex == 0;
                                final isEnabled = isCompleted || isNextTopic || isFirstTopic;
                                final translatedTopicTitle = _translator.translate(topic["title"] as String);

                                return GestureDetector(
                                  onTap: isEnabled
                                      ? () async {
                                          await _playTapSound();
                                          await Future.delayed(const Duration(milliseconds: 1000));

                                          if (topic["title"] == "Introduction" || topicIndex == 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ConversationScreen(
                                                    chapter: classIndex + 1),
                                              ),
                                            );
                                          } else if (topic["title"] == "Chapter Quiz") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FinaleScreen(
                                                  chapterIndex: classData["chapter_number"] as int,
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
                                                  classIndex: classData["chapter_number"] as int,
                                                  topicIndex: topicIndex,
                                                  learningPackage: const {},
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      : () => ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(_translator.translate('complete_previous_topic'))),
                                          ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Opacity(
                                      opacity: isEnabled ? 1.0 : 0.5,
                                      child: MyTimeLineTile(
                                        key: ValueKey("$classIndex-$topicIndex"),
                                        isFirst: topic["isFirst"] as bool,
                                        isLast: topic["isLast"] as bool,
                                        isPast: isCompleted,
                                        image: topic["image"] as String,
                                        text: translatedTopicTitle,
                                        color: isCompleted
                                            ? Colors.green
                                            : isNextTopic
                                                ? Colors.orangeAccent
                                                : classData["color"] as Color,
                                        subColor: classData["subColor"] as Color,
                                        chapterIndex: classIndex + 1,
                                        topicIndex: topicIndex,
                                        isNextTopic: isNextTopic,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _pageIndex,
              
              navKey: _navKey,
              audioPlayer: _audioPlayer,
            ),
          );
        },
      ),
    );
  }
}