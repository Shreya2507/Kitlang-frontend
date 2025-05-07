import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/appstate.dart';

class AvatarPickerScreen extends StatefulWidget {
  final bool fromSettings;

  const AvatarPickerScreen({super.key, this.fromSettings = false});

  @override
  State<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends State<AvatarPickerScreen> {
  List<String> avatarUrls = [];
  int? selectedAvatarIndex;

  @override
  void initState() {
    super.initState();
    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    final String jsonString =
        await rootBundle.loadString('assets/onboarding/avatars.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      avatarUrls = List<String>.from(jsonData['avatars']);
    });
  }

  void _saveAvatar() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final String userId = store.state.userId ?? "";

    if (userId.isEmpty || selectedAvatarIndex == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'avatarIndex': selectedAvatarIndex,
    });

    if (widget.fromSettings) {
      Navigator.pop(context, selectedAvatarIndex);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fromSettings ? "Change Avatar" : "Choose Avatar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: avatarUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: avatarUrls.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = selectedAvatarIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedAvatarIndex = index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(color: Colors.deepPurple, width: 3)
                                : null,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatarUrls[index]),
                            radius: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (selectedAvatarIndex != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: _saveAvatar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      child: Text(
                        widget.fromSettings ? "Save Changes" : "Save Avatar",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
