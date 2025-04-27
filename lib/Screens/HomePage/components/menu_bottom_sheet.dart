import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/Chat/getStartedPage.dart';
import 'package:frontend/Screens/MiniGames/Hangman/hangman_start_screen.dart';
import 'package:frontend/Screens/MiniGames/Wordle/wordle_start_screen.dart';
import 'package:frontend/Screens/SnapLearn/snap.dart';
import 'package:frontend/Screens/TranslateImage/translateImage.dart';
import 'package:audioplayers/audioplayers.dart';

void showMenuBottomSheet(BuildContext context, AudioPlayer audioPlayer) {
  _showMenuBottomSheet() {
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
