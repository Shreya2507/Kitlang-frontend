// widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTap;

  const MainScaffold({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 211, 222, 250),
        buttonBackgroundColor: Color.fromARGB(255, 182, 201, 255),
        height: 60,
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Icon(Icons.menu, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.home, size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.emoji_events,
              size: 30, color: Color.fromARGB(255, 56, 107, 246)),
          Icon(Icons.person,
              size: 30, color: Color.fromARGB(255, 56, 107, 246)),
        ],
        onTap: onTap,
      ),
    );
  }
}
