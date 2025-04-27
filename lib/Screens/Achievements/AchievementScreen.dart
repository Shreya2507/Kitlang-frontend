import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/Dictionary/Dict.dart';
import 'package:frontend/Screens/HomePage/components/custom_bottom_navbar.dart';
import 'package:frontend/Screens/HomePage/components/menu_bottom_sheet.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/Screens/UserProfile/settings/translation.dart';
import 'package:frontend/redux/appstate.dart';

import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:collection/collection.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int _pageIndex = 3;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  final ScreenshotController screenshotController = ScreenshotController();
  final translationService = TranslationService();

  final List<Map<String, dynamic>> achievements = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    achievements.clear();
    achievements.addAll([
      {
        "title": translationService.translate("First Step!"),
        "description":
            translationService.translate("Completed your first topic 🎉"),
        "unlockCondition": (List<Map<String, int>> topics) => topics.isNotEmpty,
        "badgeImage": "assets/languages/badge.png",
      },
      {
        "title": translationService.translate("Chapter Champ"),
        "description": translationService.translate("Completed 5 topics 🧠"),
        "unlockCondition": (List<Map<String, int>> topics) =>
            topics.length >= 5,
        "badgeImage": "assets/onboarding/bronze.png",
      },
      {
        "title": translationService.translate("Mastermind"),
        "description": translationService.translate("Completed 10 topics 🧠"),
        "unlockCondition": (List<Map<String, int>> topics) =>
            topics.length >= 10,
        "badgeImage": "assets/onboarding/bronze.png",
      },
    ]);
  }

  Future<void> shareOrDownloadBadge(Map<String, dynamic> badge) async {
    Uint8List image = await screenshotController.captureFromWidget(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(badge["badgeImage"], width: 300),
              Text(badge["title"],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(badge["description"], textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file =
        await File('${tempDir.path}/${badge['title'].replaceAll(" ", "_")}.png')
            .create();
    await file.writeAsBytes(image);

    await Share.shareXFiles([XFile(file.path, name: "${badge['title']}.png")],
        text: "I just unlocked '${badge['title']}' badge in MyApp! 🎉");
  }

  Future<bool> _onWillPop() async {
    final store = StoreProvider.of<AppState>(context);
    if (store.state.userId != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StoreConnector<AppState, Map<String, dynamic>>(
        converter: (store) => store.state.completedTopics,
        builder: (context, completedTopicsMap) {
          final List<Map<String, int>> completedTopics =
              completedTopicsMap.entries.map((entry) {
            final data = entry.value as Map<String, dynamic>;
            return {
              "chapter_number": data['chapter_number'] as int,
              "topic_number": data['topic_number'] as int,
            };
          }).toList();

          int totalExercises = 20;
          int completedCount = completedTopics.length;
          double progress = completedCount / totalExercises;

          final groupedByChapter = groupBy(completedTopics,
              (Map<String, int> topic) => topic['chapter_number']);
          int chaptersCompleted = groupedByChapter.length;
          int topicsCompleted = completedTopics.length;

          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurpleAccent.shade200,
                    Colors.deepPurple.shade100,
                    Colors.deepPurple.shade50,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      translationService.translate("Achievements"),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurpleAccent
                                        .withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: 180,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 16,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.3),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${(progress * 100).round()}%",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        translationService
                                            .translate("Overall Progress"),
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        translationService
                                            .translate("Chapters Completed"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "$chaptersCompleted",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        translationService
                                            .translate("Topics Completed"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "$topicsCompleted",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(16),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: achievements.map((achievement) {
                                bool unlocked = achievement['unlockCondition'](
                                    completedTopics);

                                return GestureDetector(
                                  onTap: unlocked
                                      ? () => shareOrDownloadBadge(achievement)
                                      : null,
                                  child: Opacity(
                                    opacity: unlocked ? 1.0 : 0.4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 8,
                                            offset: const Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            achievement["badgeImage"],
                                            width: 80,
                                            height: 80,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            achievement["title"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            achievement["description"],
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomBottomNavBar(
                      currentIndex: _pageIndex,
                      onTap: _onTap,
                      navKey: _navKey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
