import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/appstate.dart';

import 'AvatarPickerScreen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = true;
  List<String> avatarUrls = [];
  int? avatarIndex;

  @override
  void initState() {
    super.initState();
    _loadAvatars();
    _loadUserData();
  }

  Future<void> _loadAvatars() async {
    final String jsonString =
        await rootBundle.loadString('assets/avatars.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      avatarUrls = List<String>.from(jsonData['avatars']);
    });
  }

  Future<void> _loadUserData() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final String userId = store.state.userId ?? "";

    if (userId.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _nameController.text = data['displayName'] ?? '';
        _emailController.text = data['email'] ?? '';
        avatarIndex = data['avatarIndex'];
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    setState(() => isLoading = false);
  }

  void _updateProfile() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final String userId = store.state.userId ?? "";

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'displayName': _nameController.text,
        'email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      // Delay briefly so user sees the snackbar, then navigate back
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pop(context); // This takes you back to UserProfile screen
      });
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _openAvatarPicker() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvatarPickerScreen()),
    );

    if (selected != null && selected is int) {
      setState(() {
        avatarIndex = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAvatar = (avatarIndex != null && avatarIndex! < avatarUrls.length)
        ? avatarUrls[avatarIndex!]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
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
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _openAvatarPicker,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userAvatar != null
                            ? NetworkImage(userAvatar)
                            : NetworkImage(
                                "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text("Save Changes",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
