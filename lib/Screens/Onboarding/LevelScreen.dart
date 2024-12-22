import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/levels.jpg',
              fit: BoxFit.cover,
            ),
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
          flagPath: 'assets/onboarding/bronze.png',
          language: 'Tier 1: Word Collector',
        ),
        LevelTile(
          flagPath: 'assets/onboarding/silver.png',
          language: 'Tier 2: Fluent Fighter',
        ),
        LevelTile(
          flagPath: 'assets/onboarding/gold.png',
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
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(flagPath, width: 60),
        title: Text(language),
        onTap: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }
}
