import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/UserProfile/AvatarPickerScreen.dart';

class LevelScreen extends StatelessWidget {
  final String userId;
  final bool fromSettings;

  const LevelScreen({
    super.key,
    required this.userId,
    this.fromSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/onboarding/levels.jpg', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: LanguageList(userId: userId, fromSettings: fromSettings),
          ),
        ],
      ),
    );
  }
}

class LanguageList extends StatelessWidget {
  final String userId;
  final bool fromSettings;

  const LanguageList({
    super.key,
    required this.userId,
    required this.fromSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LevelTile(
          flagPath: 'assets/onboarding/bronze.png',
          language: 'Tier 1: Word Collector',
          levelKey: 'beginner',
          userId: userId,
          fromSettings: fromSettings,
        ),
        LevelTile(
          flagPath: 'assets/onboarding/silver.png',
          language: 'Tier 2: Fluent Fighter',
          levelKey: 'intermediate',
          userId: userId,
          fromSettings: fromSettings,
        ),
        LevelTile(
          flagPath: 'assets/onboarding/gold.png',
          language: 'Tier 3: Linguistic Legend',
          levelKey: 'advanced',
          userId: userId,
          fromSettings: fromSettings,
        ),
      ],
    );
  }
}

class LevelTile extends StatelessWidget {
  final String flagPath;
  final String language;
  final String levelKey;
  final String userId;
  final bool fromSettings;

  const LevelTile({
    required this.flagPath,
    required this.language,
    required this.levelKey,
    required this.userId,
    required this.fromSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 193, 142, 142),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(flagPath, width: 60),
        title: Text(language),
        onTap: () async {
          // Save the short key like 'beginner' to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set({'level': levelKey}, SetOptions(merge: true));

          if (fromSettings) {
            Navigator.pop(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AvatarPickerScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
