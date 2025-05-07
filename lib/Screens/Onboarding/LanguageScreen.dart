import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/Onboarding/LevelScreen.dart';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';


class LanguageScreen extends StatelessWidget {
  final bool fromSettings; // <-- NEW
  const LanguageScreen({super.key, this.fromSettings = false});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String?>(
      converter: (store) => store.state.userId,
      builder: (context, userId) {
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
                child: LanguageListView(userId: userId, fromSettings: fromSettings),
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
  final bool fromSettings;

  const LanguageListView({
    super.key,
    required this.userId,
    this.fromSettings = false,
  });

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
            fromSettings: fromSettings,
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
  final bool fromSettings;

  const LanguageTile({
    required this.flagPath,
    required this.language,
    required this.userId,
    this.fromSettings = false,
    super.key,
  });

  Future<void> _saveLanguageToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'language': language, // Save language to Firestore
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
        await _saveLanguageToFirestore();

        // Dispatch to Redux to store the language
        StoreProvider.of<AppState>(context).dispatch(SetUserLanguageAction(language));

        if (fromSettings) {
          Navigator.pop(context);
        } else {
          // Otherwise, navigate to the LevelScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelScreen(userId: userId, fromSettings: fromSettings),
            ),
          );
        }
      },
    );
  }
}
