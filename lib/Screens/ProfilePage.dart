import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTabIndex = 0; // Keeps track of the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC6D5),
              Color(0xFFF5E1ED),
              Color(0xFFF1ECF6),
              Color(0xFFF0EFF9),
              Color(0xFFFFF5E8),
              Color(0xFFFEF6E9),
              Color(0xFFFBF0E1),
              Color(0xFFF4E5F1),
              Color(0xFFFFC6D5),
            ],
            stops: [
              0.0,
              0.15,
              0.19,
              0.22,
              0.30,
              0.52,
              0.75,
              0.88,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/profile/arrow_icon.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Back',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Color(0xFF437D28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // CircleAvatar
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: CircleAvatar(
                    radius: 53, // Radius of the circular avatar
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/profile/cat.png', // cat image
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ),
                // Cat hands image
                Image.asset(
                  'assets/profile/catHands.png',
                  fit: BoxFit.cover,
                  width: 380,
                  height: 70,
                ),
                // horizontal bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color.fromARGB(255, 216, 216, 216),
                  height: 1,
                  width: double.infinity,
                ),
                // White div and tabs
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTab("General", 0),
                      _buildTab("Streak🔥", 1),
                      _buildTab("Goals", 2),
                    ],
                  ),
                ),
                const SizedBox(height: 1),

                //white container shown when a tab is selected
                Visibility(
                  visible: selectedTabIndex >= 0,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Selected Tab: ${selectedTabIndex == 0 ? 'General' : selectedTabIndex == 1 ? 'Streak🔥' : 'Goals'}",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // const SizedBox(height: 10), // COMMENTED TO SET FOR MY PHONE SCREEN

                Expanded(child: Container()),

                // Stack to overlay text on the editButton.png image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Image (editButton.png)
                    Image.asset(
                      'assets/profile/editButton.png',
                      height: 250,
                      width: 250,
                    ),
                    // GestureDetector for the text
                    Positioned(
                      bottom: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.lato(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF837977),
                            ),
                            children: [
                              TextSpan(
                                text: "Want to ",
                              ),
                              TextSpan(
                                text: "Edit",
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEA4877),
                                ),
                              ),
                              TextSpan(
                                text: " Profile?",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Building each tab
  Widget _buildTab(String label, int index) {
    bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9C0D6) : const Color(0xFFF6DCE9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Color(0xFF5B4473),
          ),
        ),
      ),
    );
  }
}
