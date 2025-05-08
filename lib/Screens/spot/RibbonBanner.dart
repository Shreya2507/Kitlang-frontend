import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RibbonBanner extends StatelessWidget {
  const RibbonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left capsule shadow
            Positioned(
              left: 1,
              bottom: 5,
              child: Container(
                height: 40,
                width: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 219, 94, 49),
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            // Right capsule shadow
            Positioned(
              right: 1,
              bottom: 5,
              child: Container(
                height: 40,
                width: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 198, 84, 49),
                      const Color.fromARGB(255, 255, 173, 59),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            // Main front capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.yellow],
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Left dot inside the Stack, so we can position it
                  Stack(
                    children: [
                      Container(
                        height: 10, // Diameter of the dot
                        width: 10, // Diameter of the dot
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(
                                255,
                                100,
                                167,
                                227,
                              ), // Lighter color for the top part
                              const Color.fromARGB(
                                255,
                                42,
                                75,
                                159,
                              ), // Darker color for the bottom part
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: Offset(0, 2), // Shadow direction (bottom)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),

                  // Outlined Text using Nunito
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Stroke Text
                      Text(
                        'Find all objects!',
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = const Color.fromARGB(
                                255,
                                138,
                                138,
                                138,
                              ),
                          ),
                        ),
                      ),
                      // Filled Text
                      Text(
                        'Find all objects!',
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 241, 215),
                            shadows: [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),
                  // Right dot inside the Stack, so we can position it
                  Stack(
                    children: [
                      Container(
                        height: 10, // Diameter of the dot
                        width: 10, // Diameter of the dot
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(
                                255,
                                68,
                                215,
                                255,
                              ), // Lighter color for the top part
                              Colors.blue
                                  .shade700, // Darker color for the bottom part
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: Offset(0, 2), // Shadow direction (bottom)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CapsuleShadow extends StatelessWidget {
  final Color color;

  const CapsuleShadow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
