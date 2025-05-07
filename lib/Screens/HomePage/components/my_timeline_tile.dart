import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_card.dart';

class MyTimeLineTile extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String image;
  final String text;
  final Color color;
  final Color subColor;
  final int chapterIndex;
  final int topicIndex;
  final bool isNextTopic;

  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.image,
    required this.text,
    required this.color,
    required this.subColor,
    required this.chapterIndex,
    required this.topicIndex,
    required this.isNextTopic,
  });

  @override
  _MyTimeLineTileState createState() => _MyTimeLineTileState();
}

class _MyTimeLineTileState extends State<MyTimeLineTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  bool isCompleted = false;
  bool isNextTopic = false;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -40.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    checkIfCompleted();
  }

  Future<void> checkIfCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(user.uid)
          .get();
      final data = doc.data();
      if (data == null) return;

      final completedTopics =
          data['completed_topics'] as Map<String, dynamic>? ?? {};
      final completionKey =
          'chapter_${widget.chapterIndex}_topic_${widget.topicIndex}';
      final prevCompletionKey =
          'chapter_${widget.chapterIndex}_topic_${widget.topicIndex - 1}';

      setState(() {
        isCompleted = completedTopics.containsKey(completionKey);
        isNextTopic =
            !isCompleted && completedTopics.containsKey(prevCompletionKey);

        if (isNextTopic && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      });
    } catch (e) {
      print("Error fetching progress: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        indicatorStyle: IndicatorStyle(
          width: 30,
          height: 30,
          indicator: isNextTopic
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, _slideAnimation.value),
                      child: _buildIndicatorImage(
                          "assets/introductions/zhuaHug.gif"),
                    );
                  },
                )
              : _buildIndicatorImage(
                  isCompleted
                      ? "assets/profile/cat.png" // Static completed image
                      : "assets/profile/cat.png", // Maybe a lock or default for locked topics
                ),
        ),
        endChild: EventCard(
          isPast: widget.isPast,
          imagePath: widget.image,
          text: widget.text,
          color: isCompleted ? Colors.green : widget.color,
          subColor: widget.subColor,
        ),
      ),
    );
  }

  Widget _buildIndicatorImage(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
