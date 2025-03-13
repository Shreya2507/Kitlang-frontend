import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/levels.jpg', fit: BoxFit.cover),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 150),
            child: LanguageList(),
          ),
        ],
      ),
    );
  }
}

class LanguageList extends StatelessWidget {
  const LanguageList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        LevelTile(
          flagPath: 'assets/images/bronze.png',
          language: 'Tier 1: Word Collector',
        ),
        LevelTile(
          flagPath: 'assets/images/silver.png',
          language: 'Tier 2: Fluent Fighter',
        ),
        LevelTile(
          flagPath: 'assets/images/gold.png',
          language: 'Tier 3: Linguistic Legend',
        ),
      ],
    );
  }
}

class LevelTile extends StatelessWidget {
  final String flagPath;
  final String language;

  const LevelTile({required this.flagPath, required this.language, super.key});

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
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({'level': language}, SetOptions(merge: true));
          }
          Navigator.pushNamed(context, '/home'); // ✅ Navigate after storing
        },
      ),
    );
  }
}
