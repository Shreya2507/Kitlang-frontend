import 'package:flutter/material.dart';

void showCuteDialog(BuildContext context, Offset tapPosition) {
  final screenSize = MediaQuery.of(context).size;
  const dialogWidth = 280.0;
  const dialogHeight = 220.0;

  final left =
      (tapPosition.dx + dialogWidth > screenSize.width)
          ? screenSize.width - dialogWidth - 16
          : tapPosition.dx;

  final top =
      (tapPosition.dy + dialogHeight > screenSize.height)
          ? screenSize.height - dialogHeight - 16
          : tapPosition.dy;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            top: top,
            left: left,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Dialog Bubble
                  Container(
                    width: dialogWidth,
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
                          '👉 Just look for the items mentioned below 📝\n\n'
                          '👁️‍🗨️ Scan the picture carefully \n\n'
                          '🎯 Tap on the item when you spot it!\n\n'
                          '✨ Easy, right?',
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
          ),
        ],
      );
    },
  );
}
