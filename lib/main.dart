import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/HomePage/HomePage.dart';
import 'package:frontend/Screens/Onboarding/LevelScreen.dart';
import 'package:frontend/Screens/Onboarding/LoginScreen.dart';
import 'package:frontend/Screens/Onboarding/SignupScreen.dart';
import 'package:frontend/Screens/Onboarding/onboarding.dart';
import 'package:frontend/Screens/Onboarding/services/auth_provider.dart';
import 'package:frontend/Screens/UserProfile/settings/LanguageScreen.dart';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/fetchUserProgressMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:frontend/redux/reducer.dart';

import 'package:frontend/Screens/UserProfile/UserProfile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart'; // Import provider for language management
// Import translation service
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if user is logged in
  User? user = FirebaseAuth.instance.currentUser;
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(userId: user?.uid),
    middleware: [fetchUserProgressMiddleware],
  );

  // 🔥 Dispatch action to trigger middleware
  if (user != null) {
    print("[DEBUG] Dispatching FetchUserProgressAction...");
    store.dispatch(FetchUserProgressAction());
  }

  // Fetch user language from Firestore and set it in Redux
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final languageCode = doc.data()?['languageCode'] ?? 'en';

    // Log the fetched language code for debugging
    print("[DEBUG] Fetched languageCode from Firestore: $languageCode");

    // Dispatch action to set the language in Redux store
    store.dispatch(ChangeLanguageAction(languageCode));
    store.dispatch(SetUserLanguageAction(languageCode));
  }

  runApp(
    StoreProvider(
      store: store,
      child: AuthProvide(store: store, child: MyApp(store: store)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Builder(
        builder: (context) {
          // Listen to language change in Redux
          return StoreConnector<AppState, String?>(
            converter: (store) {
              final selectedLanguage = store.state.selectedLanguageCode;
              print(
                  "[DEBUG] selectedLanguageCode from Redux: $selectedLanguage"); // Log the language from Redux
              return selectedLanguage;
            },
            builder: (context, selectedLanguage) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: store.state.userId != null ? '/home' : '/',
                locale: Locale(selectedLanguage ??
                    'en'), // Set the app's locale to the selected language
                onGenerateRoute: (settings) {
                  final args =
                      settings.arguments as Map<String, dynamic>? ?? {};

                  switch (settings.name) {
                    case '/':
                      return MaterialPageRoute(
                          builder: (_) => const Onboarding());

                    case '/signup':
                      return MaterialPageRoute(builder: (_) => SignupScreen());

                    case '/login':
                      return MaterialPageRoute(builder: (_) => LoginScreen());

                    case '/lang':
                      return MaterialPageRoute(
                          builder: (_) => const LanguageScreen());

                    case '/level':
                      return MaterialPageRoute(
                        builder: (_) =>
                            LevelScreen(userId: args['userId'] ?? ''),
                      );

                    case '/home':
                      return MaterialPageRoute(
                          builder: (_) => const HomePage());

                    // Add settings route here
                    case '/settings':
                      return MaterialPageRoute(
                          builder: (_) => const ProfilePage());

                    default:
                      return MaterialPageRoute(
                          builder: (_) => const Onboarding());
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
