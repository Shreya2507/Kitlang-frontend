import 'package:flutter/material.dart';
import "package:timeline_tile/timeline_tile.dart";
import "event_card.dart";
import "my_timeline_tile.dart";

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String image;
  final String text;
  final Color color;
  final Color subColor;

  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.image,
    required this.text,
    required this.color,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 110, //gap between events
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: LineStyle(
            color: isPast
                ? Color.fromARGB(255, 74, 171, 63)
                : Color.fromARGB(255, 217, 217, 217),
          ),
          indicatorStyle: IndicatorStyle(
            width: 20, // Adjust size if needed
            indicator: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPast ? Color.fromARGB(255, 74, 171, 63) : color,
                  width: 3,
                ),
              ),
            ),
          ),
          endChild: EventCard(
            isPast: isPast,
            imagePath: image,
            text: text,
            color: color,
            subColor: subColor,
          ),
        ));
  }
}
