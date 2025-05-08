import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Hangman/game_screen.dart';

class HangmanStart extends StatelessWidget {
  const HangmanStart({super.key});

  @override
  Widget build(BuildContext context) {
    void _showInstructionsModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.29,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dialog Bubble
              Container(
                width: 400,
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 231, 249),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Color.fromARGB(255, 132, 181, 246),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        105,
                        153,
                        250,
                      ).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '1. Guess the hidden word one letter at a time.\n'
                      '2. Each incorrect guess brings the hangman closer to completion.\n'
                      '3. You have 6 attempts before the game ends.\n'
                      '4. Guess all letters correctly to win!',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.4,
                        color: Color.fromARGB(221, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),

              // Cute Label
              Positioned(
                top: -20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 52, 98, 158),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          1,
                          1,
                          0,
                        ).withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '🎮 How to play?',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC6D5),
              Color(0xFFFFE3B9),
              Color(0xFFFFF0D9),
              Color(0xFFFFF9F0),
              Color(0xFFFEFEFE),
              Color(0xFFFBFBFD),
              Color(0xFFF6F3FD),
              Color(0xFFE1D6FF),
              Color(0xFFB8D5FF),
            ],
            stops: [0.0, 0.09, 0.22, 0.27, 0.28, 0.67, 0.78, 0.86, 0.91],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  child: Image.asset("assets/hangman/rightLeg.png"),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "HANGMAN",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "THE GAME",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                // width: 260,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/game');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GameScreen(
                                        level: "very_easy",
                                        reveal: false,
                                      )));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        child: const Text("START"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          _showInstructionsModal(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        child: const Text("INSTRUCTIONS"),
                      ),
                    ),
                    // SizedBox(
                    //   width: 270,
                    //   height: 45,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     style: ButtonStyle(
                    //       backgroundColor:
                    //           WidgetStateProperty.all<Color>(Colors.white),
                    //       foregroundColor:
                    //           WidgetStateProperty.all<Color>(Colors.black),
                    //       shape:
                    //           WidgetStateProperty.all<RoundedRectangleBorder>(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(25),
                    //         ),
                    //       ),
                    //     ),
                    //     child: const Text("OPTIONS"),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
