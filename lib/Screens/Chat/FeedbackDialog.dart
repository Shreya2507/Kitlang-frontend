import 'package:flutter/material.dart';
import 'package:frontend/Screens/Chat/allChat.dart';

class FeedbackDialog {
  static void show({
    required BuildContext context,
    required String feedback,
    required double fluency,
    required double relevance,
    required double score,
    required double vocabulary,
    required VoidCallback onOkayPressed,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      const Text(
                        "Evaluation Result",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 42, 42, 42),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        feedback,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Performance Metrics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 240, 109, 99),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      _buildMetricRow(
                        'images/icons/star.png',
                        'Fluency',
                        fluency,
                      ),
                      const SizedBox(height: 10),
                      _buildMetricRow(
                        'images/icons/tick.png',
                        'Relevance',
                        relevance,
                      ),
                      const SizedBox(height: 10),
                      _buildMetricRow(
                        'images/icons/rocket.png',
                        'Score',
                        score,
                      ),
                      const SizedBox(height: 10),
                      _buildMetricRow(
                        'images/icons/book.png',
                        'Vocabulary',
                        vocabulary,
                      ),
                      const SizedBox(height: 20),
                      // const Text(
                      //   "Suggestions",
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //     color: Color.fromARGB(255, 240, 109, 99),
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // Row(
                      //   children: [
                      //     const SizedBox(width: 8),
                      //     Flexible(
                      //       child: Text(
                      //         suggestions,
                      //         style: const TextStyle(
                      //           fontSize: 12,
                      //           color: Color.fromARGB(255, 55, 55, 55),
                      //         ),
                      //         maxLines: 5,
                      //         overflow: TextOverflow.ellipsis,
                      //         textAlign: TextAlign.left,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            onOkayPressed(); // 👈 use the passed callback to close the WebSocket
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllChat(),
                              ),
                            );
                          },
                          child: const Text("Okay"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   top: 10,
              //   right: 10,
              //   child: IconButton(
              //     icon: const Icon(
              //       Icons.close,
              //       color: Color.fromARGB(255, 28, 29, 29),
              //       size: 30,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              // ),
              // Positioned(
              //   top: 8,
              //   left: 15,
              //   child: IconButton(
              //     icon: const Icon(
              //       Icons.arrow_back,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildMetricRow(String iconPath, String label, double value) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20, height: 20),
        const SizedBox(width: 8),
        Text('$label: $value/10'),
      ],
    );
  }
}
