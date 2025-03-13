import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Onboarding.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 28.0, color: Colors.black),
                      // children: <TextSpan>[
                      //   TextSpan(
                      //       text: 'Hi! ',
                      //       style: TextStyle(fontWeight: FontWeight.bold)),
                      //   TextSpan(
                      //     text:
                      //         'Ready to explore the new language in a fun way',
                      //   ),
                      // ],
                    ),
                  ),
                ),
                const SizedBox(height: 200),
                SizedBox(
                  width: 340,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      "GET STARTED",
                      style: TextStyle(
                        color: Color.fromRGBO(252, 26, 26, 1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
