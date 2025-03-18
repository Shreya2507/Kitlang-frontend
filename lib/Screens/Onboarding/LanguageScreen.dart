import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/appstate.dart';

import 'LevelScreen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String?>(
      converter: (store) => store.state.userId,
      builder: (context, userId) {
        print('🔹 User ID from Redux Store: $userId');
        if (userId == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/onboarding/Languages.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: LanguageListView(userId: userId),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LanguageListView extends StatelessWidget {
  final String userId;
  const LanguageListView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          LanguageTile(
            flagPath: 'assets/onboarding/germany_flag.png',
            language: 'German',
            userId: userId,
          ),
        ],
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String flagPath;
  final String language;
  final String userId;

  const LanguageTile({
    required this.flagPath,
    required this.language,
    required this.userId,
    super.key,
  });

  Future<void> _saveLanguageToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'selectedLanguage': language,
      });
      print('✅ Language saved: $language');
    } catch (e) {
      print('❌ Error saving language: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(flagPath, width: 30),
      title: Text(language),
      onTap: () async {
        await _saveLanguageToFirestore(); // Save to Firestore
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LevelScreen(userId: userId)),
        );
      },
    );
  }
}
