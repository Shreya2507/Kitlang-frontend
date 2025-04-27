import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/UserProfile/EditProfile.dart';
import 'package:frontend/Screens/UserProfile/ReferFriend.dart';
import 'package:frontend/Screens/UserProfile/StreakTab.dart';
import 'package:frontend/Screens/UserProfile/settings/UserProfileSettings.dart';
import 'package:frontend/Screens/UserProfile/settings/translation.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTabIndex = 0;
  String? avatarUrl;
  bool avatarLoading = true;
  bool _isLanguageLoaded = false;
  final TranslationService _translator = TranslationService();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    loadAvatar();
  }

  Future<void> _loadLanguage() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final selectedLang = store.state.selectedLanguageCode ?? 'en';
    await _translator.setLanguage(selectedLang);
    setState(() {
      _isLanguageLoaded = true;
    });
  }

  Future<void> loadAvatar() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/avatars.json');
      final data = json.decode(jsonString);
      final List<dynamic> avatars = data['avatars'];

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final avatarIndex = doc.data()?['avatarIndex'] ?? 0;

      if (avatarIndex < avatars.length) {
        setState(() {
          avatarUrl = avatars[avatarIndex];
          avatarLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading avatar: $e");
      setState(() {
        avatarLoading = false;
      });
    }
  }

  void navigateToTab(int index) => setState(() => selectedTabIndex = index);

  void onGeneralItemTap(String identifier) {
    switch (identifier) {
      case "refer_friend":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ReferAFriendPage()));
        break;
      case "settings":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UserProfileSettings()));
        break;
      case "feedback":
        // Handle feedback navigation
        break;
      case "help":
        // Handle help navigation
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLanguageLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
              Color(0xFFF5E1ED),
              Color(0xFFF1ECF6),
              Color(0xFFF0EFF9),
              Color(0xFFFFF5E8),
              Color(0xFFFEF6E9),
              Color(0xFFFBF0E1),
              Color(0xFFF4E5F1),
              Color(0xFFFFC6D5),
            ],
            stops: [0.0, 0.15, 0.19, 0.22, 0.30, 0.52, 0.75, 0.88, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false),
                    child: Row(
                      children: [
                        Image.asset('assets/profile/arrow_icon.png',
                            height: 20, width: 20),
                        const SizedBox(width: 8),
                        Text(
                          _translator.translate('Back'),
                          style: GoogleFonts.lato(
                              fontSize: 14, color: const Color(0xFF437D28)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              avatarLoading
                  ? const CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 53,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl ?? 'https://i.pravatar.cc/150?img=1',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
              Image.asset('assets/profile/catHands.png',
                  fit: BoxFit.cover, width: 380, height: 70),
              Divider(color: Colors.grey.shade300, thickness: 1),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab(_translator.translate("General"), 0),
                    _buildTab(_translator.translate("Streak🔥"), 1),
                    _buildTab(_translator.translate("Goals"), 2),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
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
                child: _buildTabContent(),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/profile/editButton.png',
                      height: 250, width: 250),
                  Positioned(
                    bottom: 50,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditProfilePage())),
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.lato(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF837977)),
                          children: [
                            TextSpan(text: _translator.translate("Want to  ")),
                            TextSpan(
                              text: _translator.translate("Edit"),
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEA4877)),
                            ),
                            TextSpan(text: _translator.translate(" Profile?")),
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
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => navigateToTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9C0D6) : const Color(0xFFF6DCE9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF5B4473),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return Column(
          children: [
            _buildGeneralItem(Icons.group_add,
                _translator.translate("Refer a Friend"), "refer_friend"),
            _buildGeneralItem(
                Icons.settings, _translator.translate("Settings"), "settings"),
            _buildGeneralItem(Icons.feedback_outlined,
                _translator.translate("Feedback"), "feedback"),
            _buildGeneralItem(Icons.help_outline,
                _translator.translate("Help & Support"), "help"),
          ],
        );
      case 1:
        return const StreakTab();
      case 2:
      default:
        return Center(
          child: Text(
            _translator.translate("Selected Tab: Goals"),
            style: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        );
    }
  }

  Widget _buildGeneralItem(IconData icon, String title, String identifier) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5B4473)),
      title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => onGeneralItemTap(identifier),
    );
  }
}
