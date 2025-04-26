import 'package:flutter/material.dart';
import 'package:frontend/Screens/MiniGames/Hangman/game_screen.dart';

class HangmanStart extends StatelessWidget {
  const HangmanStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "HANGMAN",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "THE GAME",
                      style: const TextStyle(
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
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
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
                        child: const Text("HIGHSCORE"),
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
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
