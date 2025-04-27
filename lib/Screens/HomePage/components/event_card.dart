import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final bool isPast;
  final String imagePath;
  final String text;
  final Color color;
  final Color subColor;

  const EventCard({
    super.key,
    required this.isPast,
    required this.imagePath,
    required this.text,
    required this.color,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isPast ? Color.fromARGB(255, 74, 171, 63) : subColor,
            ),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
        ),
        SizedBox(
          width: 200,
          height: 80,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
