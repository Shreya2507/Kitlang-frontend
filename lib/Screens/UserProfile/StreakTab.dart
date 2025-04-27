import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakTab extends StatefulWidget {
  const StreakTab({super.key});

  @override
  _StreakTabState createState() => _StreakTabState();
}

class _StreakTabState extends State<StreakTab> {
  Map<String, List<dynamic>> completionDates = {};
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCompletionDates();
  }

  Future<void> fetchCompletionDates() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null && data['completion_dates'] != null) {
        setState(() {
          completionDates = Map<String, List<dynamic>>.from(data['completion_dates']);
          isLoading = false;
        });

        // Scroll to start (left) after layout completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    } catch (e) {
      print('Error fetching completion dates: $e');
      setState(() => isLoading = false);
    }
  }

  List<String> getLastSevenDays() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      return DateFormat('yyyy-MM-dd').format(date);
    }); // no reverse
  }

  @override
  Widget build(BuildContext context) {
    final days = getLastSevenDays(); // most recent to least recent

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Streak 🔥',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: days.map((date) {
                      final isActive = completionDates.containsKey(date);
                      final dayName = DateFormat('E').format(DateTime.parse(date));
                      final dayNum = DateFormat('d').format(DateTime.parse(date));

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? Colors.green : Colors.grey.shade300,
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : [],
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  dayNum,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.white : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dayName,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
  }
}
