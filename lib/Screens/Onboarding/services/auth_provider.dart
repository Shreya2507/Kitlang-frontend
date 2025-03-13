import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:redux/redux.dart';

class AuthProvide extends StatefulWidget {
  final Widget child;
  final Store<AppState> store;

  const AuthProvide({super.key, required this.child, required this.store});

  @override
  _AuthProviderState createState() => _AuthProviderState();
}

class _AuthProviderState extends State<AuthProvide> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        widget.store.dispatch(SetUserIdAction(user.uid));
        _fetchUserData(user.uid);
      }
    });
  }

  void _fetchUserData(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      String? level = data?['level'];
      String? language = data?['language'];

      if (level != null) {
        widget.store.dispatch(SetUserLevelAction(level));
      }
      if (language != null) {
        widget.store.dispatch(SetUserLanguageAction(language));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
