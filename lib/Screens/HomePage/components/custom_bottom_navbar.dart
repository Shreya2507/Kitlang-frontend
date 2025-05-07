import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:frontend/Screens/HomePage/homepage.dart'; 
import 'package:frontend/Screens/Dictionary/Dict.dart'; 
import 'package:frontend/Screens/Achievements/AchievementScreen.dart'; 
import 'package:frontend/Screens/UserProfile/UserProfile.dart'; 
import 'package:frontend/Screens/HomePage/components/menu_bottom_sheet.dart'; 
import 'package:audioplayers/audioplayers.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final GlobalKey<CurvedNavigationBarState> navKey;
  final AudioPlayer audioPlayer;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.navKey,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: navKey,
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: const Color.fromARGB(255, 211, 222, 250),
      buttonBackgroundColor: const Color.fromARGB(255, 182, 201, 255),
      height: 60,
      animationCurve: Curves.easeInOut,
      items: const <Widget>[
        Icon(Icons.menu, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
        Icon(Icons.home, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
        Icon(Icons.book, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
        Icon(Icons.person, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
      ],
      onTap: (index) async {
        // Play tap sound
        await audioPlayer.play(AssetSource('sounds/tap.wav'));
        
        // Handle navigation based on index
        switch (index) {
          case 0: // Menu button
            showMenuBottomSheet(context, audioPlayer);
            break;
            
          case 1: // Home button
            if (ModalRoute.of(context)?.settings.name != '/') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            }
            break;
            
          case 2: // Dictionary button
            if (ModalRoute.of(context)?.settings.name != '/dictionary') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DictionaryHomePage()),
                (route) => false,
              );
            }
            break;
            
          case 3: // Profile button
            if (ModalRoute.of(context)?.settings.name != '/profile') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
                (route) => false,
              );
            }
            break;
        }
      },
    );
  }
}