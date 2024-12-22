import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/Languages.jpg',
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
        LanguageTile(
          flagPath: 'assets/onboarding/germany_flag.png',
          language: 'German',
        ),
      ],
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String flagPath;
  final String language;

  const LanguageTile(
      {required this.flagPath, required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(flagPath, width: 30),
        title: Text(language),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, '/level');
        },
      ),
    );
  }
}
