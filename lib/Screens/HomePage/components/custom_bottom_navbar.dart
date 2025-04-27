import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final GlobalKey<CurvedNavigationBarState> navKey;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navKey,
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
      onTap: onTap,
    );
  }
}
